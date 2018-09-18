module CvHelper

  def respond_with_cv (mentor_match_profile)
    # To avoid making all CV files on gdrive public, the app acts as an authenticating proxy here. Requests for CV files are made by the user to this endpoint, and from here to gdrive, and not directly from the user's client to gdrive.
    # This is a lot less efficient than letting the user request the files directly, and gdrive DOES have great authentication/permission features... but then we'd need all our user accounts to be google accounts. This would be a GREAT future feature but has huge ramifications!

    if mentor_match_profile.original_cv_drive_id.nil?
      redirect_to request.referrer || mentor_match_profile
      return
    end

    drive = GoogleDrive.get_drive_service
    file_data = StringIO.new

    # NB: this call does NOT return a DriveV3::File, it returns the StringIO instance. gdrive is weird ¯\_(ツ)_/¯
    drive.get_file mentor_match_profile.original_cv_drive_id, download_dest: file_data

    send_data file_data.string,
    filename: mentor_match_profile.original_cv_file_name,
    type: mentor_match_profile.original_cv_mime_type

    # TODO: if this were a node app, the file data request would be async, and the data return would be async, the whole thing would be nonblocking... can rails let us do anything similar here?

  end



  def handle_cv_upload (redirection_path)

    # TODO: handle all the various exceptions the google API calls can produce
    # TODO: in a better world, we would move much of this into a task outside of the request-response cycle.

    if params[:CV].nil?
      return redirect_to request.referrer, alert: "Please choose a CV file to upload."
    end

    unless params[:CV].original_filename.match /\.(docx?|pdf|txt)$/
      return redirect_to request.referrer, alert: "Please upload your CV in .doc, .docx, .pdf, or .txt format."
    end

    if params[:CV].original_filename.match /\.docx$/
      mime_type = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    elsif params[:CV].original_filename.match /\.doc$/
      mime_type = 'application/msword'
    elsif params[:CV].original_filename.match /\.pdf$/
      mime_type = 'application/pdf'
    elsif params[:CV].original_filename.match /\.txt$/
      mime_type = 'text/plain'
    else
      # Shouldn't be possible to get here, but... 
      return redirect_to request.referrer, alert: "Please upload your CV in .doc, .docx, .pdf, or .txt format."
    end


    drive = GoogleDrive.get_drive_service
    profile = current_user.mentor_match_profile

    # TODO: technically, we could make the old CV as not searchable and then 
    # encounter an error uploading the new one. A proper app would need to
    # address this.
    unless profile.original_cv_drive_id.nil?
      # previous_cv = drive.get_file profile.original_cv_drive_id
      drive.update_file(profile.original_cv_drive_id, {properties: {"seeking"=>"false"}}, {})
    end



    # Upload the file to Google Drive


    original_file = drive.create_file( {name: params[:CV].original_filename, properties: {"seeking"=>"false", "dom_citizen_type"=>"cv_document"}
      },
      fields: 'id,mime_type,name',
      # TODO: Not sure that tempfile will always exist here, test with like a tiny tiny file
      # Update: have never seen the upload break at this point, assume this is OK.
      upload_source: params[:CV].tempfile,
      content_type: mime_type
    )


    # Finally, save our gains:

    profile.original_cv_drive_id = original_file.id

    profile.original_cv_mime_type = original_file.mime_type
    profile.original_cv_file_name = original_file.name
    profile.save!

    redirect_to (redirection_path or request.referrer), notice: "CV uploaded successfully!"

    
  end

end