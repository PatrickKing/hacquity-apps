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

end