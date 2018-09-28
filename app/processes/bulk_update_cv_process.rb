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
      @bulk_update_record.save!
    end



    s3 = Aws::S3::Resource.new region: 'us-west-2'
    obj = s3.bucket(ENV['S3_BUCKET_NAME']).object(@bulk_update_record.s3_zip_id)

    path = Pathname.new('/tmp').join(@bulk_update_record.s3_zip_id)
    path.dirname.mkpath

    obj.get(response_target: path)

    `unzip -o #{path} -d #{path.dirname}`

    csv_files = Dir[path.dirname.join('*.csv')]

    # STDERR.puts csv_files.length, csv_files[0], path.dirname.join('*.csv')

    if csv_files.length != 1
      return 'error! want exactly one CSV'
    end


    # Expectation: first column has filenames, second column has emails
    CSV.foreach csv_files[0] do |row|

      item = @bulk_update_record.bulk_update_line_items.where(email: row[1]).first_or_create

      item.filename = row[0]
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

      # TODO: error out if the file doesn't exist
      cv_file = File.new(path.dirname.join(item.filename), "r")

      # TODO: this motherfucker can fail in a bajillion ways.
      upload_cv user, item.filename, cv_file

      # Probably unnecessary, but for good measure:
      cv_file.close

      item.status = 'completed'
      item.save!

    end




    tentative_status = 'completed'

    @bulk_update_record.bulk_update_line_items.each do |item|
      if item.status == 'error_retry_permitted'
        tentative_status = 'error_retry_permitted'
      end
    end

    @bulk_update_record.status = tentative_status
    @bulk_update_record.save!


    # Cleanup:


    filenames = @bulk_update_record.bulk_update_line_items.map do |item|
      path.dirname.join(item.filename)
    end

    # Delete the CVs, the CSV file, and the .zip
    # We could delete everything under the path, but to avoid any rm -rf * disasters lets not.
    File.unlink *filenames
    File.unlink csv_files[0]
    File.unlink path

    unless @bulk_update_record.can_retry?
      # Also clean the file out of S3.
      # TODO: This should do an acceptable job of keeping the bucket clean, but if the user has a job that can retry and they neglect it for two weeks, it will disappear from the list of jobs, and we will have leaked some stuff into the bucket. When this product takes off and we sell it for a bajillion dollars we will need a task to erase old jobs + line items from the DB, and old S3 objects. Or when I get an S3 bill for $0.02 in a year's time, whichever comes first.

      obj.delete
    end


    # download the ZIP
      # errors: zip not found, couldn't save file or something
    # unzip the zip
      # errors: disk space? file not found? disk unzip util not there?
    # find the CSV, read it
      # errors: no CSV, can't read CSV, more than 1 CSV
    # ensure each line item record exists
      # per item errors: ... ?
    # per line item: 
      # locate user,
      # locate file,
      # call the CV upload process, 
      # update line item with the results
    # done! set completed statuses

    # TODO: verify that throwing an exception here causes the bulk update job to fail and retry. 

  end

  private


end








