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

  def upload_cv_via_form (redirection_path)
    result = upload_cv current_user, params[:CV]

    case result[:error]
    when :no_file
      redirect_to request.referrer, alert: "Please choose a CV file to upload."
    when :wrong_file_format
      redirect_to request.referrer, alert: "Please upload your CV in .doc, .docx, .pdf, or .txt format."
    else
      redirect_to (redirection_path || request.referrer), notice: "CV uploaded successfully!"
    end

  end

  def upload_cv_via_email (email_params)

    # Since any errors resulting from this call will be emailed to the user, and not sent to the mailgun server, we can respond early.
    # TODO: does this actually issue the HTTP response immediately? signs point to no!
    head :no_content

    user = User.where(email: email_params['sender']).first
    unless user
      CvSubmissionFailureNoUserJob.new(email_params['sender'], "We couldn't find your info. Please use the email address associated with your DoM Citizen account.").deliver
      return
    end

    # NB: all of the email tokens I have generated so far have been 22 characters long, but the docs seem to imply that the length can vary? I don't know, but out of an abundance of caution, I've allowed some wiggle room on the token length.
    # https://ruby-doc.org/stdlib-2.1.3/libdoc/securerandom/rdoc/SecureRandom.html#method-c-urlsafe_base64
    # matching tokens like: 6cyGV_hhz-KH6gI-JTJnCQ
    email_token_regex = /\[CV Receipt Token = ([A-Za-z0-9\-_]{20,23})\]/

    html_match = (email_params['body-html'] || '').match email_token_regex
    text_match = (email_params['body-text'] || '').match email_token_regex

    html_token = html_match ? html_match[1] : nil
    text_token = text_match ? text_match[1] : nil
    token = html_token || text_token

    if not token or user.cv_receipt_token != token
      # This is a little weird, we've found the user but couldn't confirm the token. I may just be being paranoid, but I'm insisting that we get a token from the user because I'm not 100% sure I trust the 'sender' parameter, senders can be spoofed right? How much validation does mailgun do on incoming email?
      # NB: we use the 'no user' failure email, because ordinary failure email *includes the token*.
      CvSubmissionFailureNoUserJob.new(email_params['sender'], "We couldn't confirm your identity. Please reply to an email sent by the DoM Citizen CV update service.").deliver
      return
    end

    if email_params["attachment-count"] != '1'

      count_info = email_params["attachment-count"] ? "There were #{email_params["attachment-count"]} files attached. " : ''

      CvSubmissionFailureJob.new(user, "We couldn't find your attachment. #{count_info}Please reply with only one file in .docx, .doc, .pdf, or .txt file attached.").deliver
      return
    end

    result = upload_cv user, email_params["attachment-1"]

    case result[:error]
    when :no_file
      # this is probably redundant with the attachment-count case above, but I'm leaving it in.
      CvSubmissionFailureJob.new(user, "We couldn't find your attachment. Please attach only one file in .docx, .doc, .pdf, or .txt format.").deliver
    when :wrong_file_format
      CvSubmissionFailureJob.new(user, "Your CV was in a format we couldn't read. Please attach one file in .docx, .doc, .pdf, or .txt format.").deliver
    else
      CvSubmissionSuccessJob.new(user).deliver
    end

  end


  private

  def upload_cv (user, cv_tempfile)

    # TODO: handle all the various exceptions the google API calls can produce
    # TODO: in a better world, we would move much of this into a task outside of the request-response cycle.

    result = {
      error: nil,
    }

    if cv_tempfile.nil?
      result[:error] = :no_file
      return result
    end

    unless cv_tempfile.original_filename.match /\.(docx?|pdf|txt)$/
      result[:error] = :wrong_file_format
      return result
    end

    if cv_tempfile.original_filename.match /\.docx$/
      mime_type = 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
    elsif cv_tempfile.original_filename.match /\.doc$/
      mime_type = 'application/msword'
    elsif cv_tempfile.original_filename.match /\.pdf$/
      mime_type = 'application/pdf'
    elsif cv_tempfile.original_filename.match /\.txt$/
      mime_type = 'text/plain'
    else
      # Shouldn't be possible to get here, but... 
      result[:error] = :wrong_file_format
      return result
    end


    drive = GoogleDrive.get_drive_service
    profile = user.mentor_match_profile

    # TODO: technically, we could mark the old CV as not searchable and then 
    # encounter an error uploading the new one. A proper app would need to
    # address this.
    unless profile.original_cv_drive_id.nil?
      drive.delete_file profile.original_cv_drive_id
      profile.original_cv_drive_id = nil
      profile.save!
    end



    # Upload the file to Google Drive:

    original_file = drive.create_file( {name: cv_tempfile.original_filename, properties: {"seeking"=>profile.seeking?, "dom_citizen_type"=>"cv_document"}
      },
      fields: 'id,mime_type,name',
      # TODO: Not sure that tempfile will always exist here, test with like a tiny tiny file
      # Update: have never seen the upload break at this point, assume this is OK.
      upload_source: cv_tempfile.tempfile,
      content_type: mime_type
    )




    # TODO: in a better world: move this scan operation into a separate job

    # Create a google doc copy of the file:
    gdoc_file = Google::Apis::DriveV3::File.new
    gdoc_file.mime_type = 'application/vnd.google-apps.document'
    gdoc_file = drive.copy_file original_file.id, gdoc_file

    # Download a text only extraction of the file, and scan it for contact information:
    cv_text = drive.export_file gdoc_file.id, 'text/plain', download_dest: StringIO.new

    # We don't need the gdoc file long term
    drive.delete_file gdoc_file.id

    # Lots of assumptions at work with my regexes!
    # No phone numbers in Calgary are less than 10 digits, this will potentially match other clusters of numbers with dashes and spaces if they're long enough:
    phone_hits = cv_text.string.scan /(?:[()+-. ]|\d){10,}/
    # Emails pretty much just have a @ in them:
    email_hits = cv_text.string.scan /((?:[.+]|\w)+@(?:[.+]|\w)+)/
    postal_code_hits = cv_text.string.scan /[a-z]\d[a-z][- ]?\d[a-z]\d/i
    # To avoid too many false positives, scan case insensitive for street suffixes fully spelled out, but require all caps for abbreviations.
    street_suffix_hits = cv_text.string.scan /\bavenue\b|\broad\b|\bstreet\b|\bboulevard\b|\blane\b|\bdrive\b|\bterrace\b|\bplace\b|\bcourt\b|\bplaza\b|\bparkway\b|\bgrove\b|\bgardens\b|\bcircus\b|\bcrescent\b|\bclose\b|\bsquare\b|\bhill\b|\bmews\b|\bexpressway\b|\bfreeway\b|\bhighway\b|\blanding\b/i
    street_suffix_abbreviation_hits = cv_text.string.scan /ST|AVE|BLVD/
    # Could scan for additional abbreviations, like CR|CT|RD|TR|PL|PW, worried about false positives. Given that they are doctors we cannot scan for DR =/

    personal_information = phone_hits.concat(email_hits, postal_code_hits,street_suffix_hits, street_suffix_abbreviation_hits).flatten.join "\n"

    # Save our gains:
    profile.original_cv_drive_id = original_file.id
    profile.original_cv_mime_type = original_file.mime_type
    profile.original_cv_file_name = original_file.name
    profile.personal_information = personal_information
    profile.save!

    return result

  end

end