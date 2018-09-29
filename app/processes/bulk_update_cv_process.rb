require 'aws-sdk'
require 'csv'

# I didn't want to store transient state about the bulk upload process on either the record (which is database backed and mostly for informing the user about what's going on) or the delayedjob object (which is also database backed and really just for delayedjob's use). To avoid any possiblity of storing stale data, this object exists only while we're doing work.
class BulkUpdateCvProcess

  include CvHelper

  def initialize (bulk_update_record)
    @bulk_update_record = bulk_update_record
  end

  def run

    if @bulk_update_record.status == 'completed' or 
       @bulk_update_record.status == 'error_no_retry' or
       @bulk_update_record.status == 'in_progress'
      return
    else
      # Though we do not check it here, we expect the status to be one of created, error_retry_permitted or will_retry. If the user triggers a retry through the UI, the status should be will_retry, but if triggered at the CLI it may be error_retry_permitted.
      @bulk_update_record.status = 'in_progress'
      @bulk_update_record.error_message = nil
      @bulk_update_record.save!
    end

    s3 = Aws::S3::Resource.new region: 'us-west-2'
    @obj = s3.bucket(ENV['S3_BUCKET_NAME']).object(@bulk_update_record.s3_zip_id)

    @path = Pathname.new('/tmp').join(@bulk_update_record.s3_zip_id)
    @path.dirname.mkpath

    begin
      @obj.get(response_target: @path)
    rescue Aws::S3::Errors::NoSuchKey => error
      @bulk_update_record.status = 'error_no_retry'
      @bulk_update_record.error_message = "We lost the .zip file you uploaded. Sorry! Please create a new job."
      @bulk_update_record.save!
      return
    end


    unzip_result = system "unzip -o #{@path} -d #{@path.dirname}"
    if unzip_result == false
      @bulk_update_record.status = 'error_no_retry'
      @bulk_update_record.error_message = "We had an unexpected problem processing this job. (Couldn't extract zip file.)"
      @bulk_update_record.save!
      cleanup
      return
    end

    @csv_files = Dir[@path.dirname.join('*.csv')]
    if @csv_files.length != 1
      @bulk_update_record.status = 'error_no_retry'
      @bulk_update_record.error_message = "We found #{@csv_files.length} .csv file(s) in the .zip file. Please include exactly one .csv file."
      @bulk_update_record.save!
      cleanup
      return
    end

    # Expectation: first column has filenames, second column has emails
    CSV.foreach @csv_files[0] do |row|
      item = @bulk_update_record.bulk_update_line_items.where(email: row[1]).first_or_create

      item.filename = row[0]
      item.save!
    end


    cv_files = @bulk_update_record.bulk_update_line_items.select do |item|
      not item.email.blank?
    end.map do |item|
      item.filename
    end
    all_files = Dir[@path.dirname.join('*')].map do |path|
      Pathname.new(path).basename.to_s
    end
    csv_filenames = @csv_files.map do |path|
      Pathname.new(path).basename.to_s
    end

    other_files = all_files - cv_files - csv_filenames - [@path.basename.to_s]
    other_files.each do |other_file|
      item = @bulk_update_record.bulk_update_line_items.where(filename: other_file).first_or_create
      item.email = nil
      item.status = 'error_no_retry'
      item.error_message = "File '#{other_file}' was not listed in the .csv file."
      item.save!
    end


    @bulk_update_record.reload

    @bulk_update_record.bulk_update_line_items.each do |item|
      next if item.status == 'error_no_retry' or item.status == 'completed'

      user = User.where(email: item.email).first
      if not user
        # Retry is permitted here, because if the admin creates this user this item can succeed.
        item.status = 'error_retry_permitted'
        item.error_message = "User account for #{item.email} not found. Please check the spelling of the email address, or create an account for this user."
        item.save!
        next
      end

      begin
        cv_file = File.new(@path.dirname.join(item.filename), "r")
      rescue Errno::ENOENT => error
        item.status = 'error_no_retry'
        item.error_message = "No file named '#{item.filename}' in the .zip file."
        item.save!
        next
      end

      upload_result = upload_cv user, item.filename, cv_file

      if upload_result[:error] == :no_file
        # Shouldn't be possible to see this error since we handle it above, but handle it anyway.
        item.status = 'error_no_retry'
        item.error_message = "No file named '#{item.filename}' in the .zip file."
        item.save!
        next
      elsif upload_result[:error] == :wrong_file_format
        item.status = 'error_no_retry'
        item.error_message = "CV '#{item.filename}' was in a format we couldn't read. Please attach a file in .docx, .doc, .pdf, or .txt format."
        item.save!
        next
      end

      # Probably unnecessary, but for good measure:
      cv_file.close

      item.status = 'completed'
      item.error_message = nil
      item.save!

    end


    tentative_status = 'completed'

    @bulk_update_record.bulk_update_line_items.each do |item|
      if item.status == 'error_retry_permitted'
        tentative_status = 'error_retry_permitted'
      end
    end

    # If every single item hits an unrecoverable error, we'll consider the overall job failed also.
    if tentative_status == 'completed'
      errored_items = @bulk_update_record.bulk_update_line_items.select do |item|
        item.status == 'error_no_retry'
      end
      if errored_items.length == @bulk_update_record.bulk_update_line_items.length
        tentative_status = 'error_no_retry'
      end
    end

    @bulk_update_record.status = tentative_status
    @bulk_update_record.save!

    cleanup




  # Throwing an exception here causes the delayedjob to fail and retry. Instead, we take the slightly risky step of rescuing everything and attempting to set an error message for the user. If THIS fails, well, all bets are off. 
  rescue StandardError => error
    @bulk_update_record.status = 'error_no_retry'
    @bulk_update_record.error_message = "We had an unexpected problem processing this job. (#{error.message})"
    @bulk_update_record.save
    cleanup
  end

  private


  def cleanup

    # Delete the CVs, the CSV file, and the .zip
    # We could delete everything under the path, but to avoid any rm -rf * disasters lets not.
    begin
      filenames = @bulk_update_record.bulk_update_line_items.map do |item|
        @path.dirname.join(item.filename)
      end
      File.unlink *filenames
    rescue Errno::ENOENT => error
    end

    @csv_files.each do |filename|
      begin
        File.unlink filename
      rescue Errno::ENOENT => error
      end
    end

    begin
      File.unlink @path
    rescue Errno::ENOENT => error
    end

    unless @bulk_update_record.can_retry?
      # Also clean the file out of S3.
      # TODO: This should do an acceptable job of keeping the bucket clean, but if the user has a job that can retry and they neglect it for two weeks, it will disappear from the list of jobs, and we will have leaked some stuff into the bucket. When this product takes off and we sell it for a bajillion dollars we will need a task to erase old jobs + line items from the DB, and old S3 objects. Or when I get an S3 bill for $0.02 in a year's time, whichever comes first.

      begin
        @obj.delete
      rescue Aws::S3::Errors::ServiceError => error
      end
    end

  end

end








