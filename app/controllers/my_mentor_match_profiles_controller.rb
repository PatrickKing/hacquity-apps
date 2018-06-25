
require './app/models/concerns/GoogleDrive'

class MyMentorMatchProfilesController < ApplicationController
  
  before_action :require_login

  before_action :set_mentor_match_profile, only: [:show, :edit, :update]

  layout "mentor_match_pages"


  def show
  end


  def edit
  end



  def update
    if @mentor_match_profile.update(mentor_match_profile_params)
      redirect_to my_mentor_match_profile_path, notice: 'Mentor match profile was successfully updated.'
    else
      render :edit
    end
  end

  

  def upload_profile
    # TODO: handle all the various exceptions the google API calls can produce
    # TODO: in a better world, we would move much of this into a task outside of the request-response cycle.

    if params[:CV].nil?
      return redirect_to mentor_match_path, alert: "Please choose a CV file to upload."
    end

    unless params[:CV].original_filename.match /\.(docx?|pdf|txt)$/
      return redirect_to mentor_match_path, alert: "Please upload your CV in .doc, .docx, .pdf, or .txt format."
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
      return redirect_to mentor_match_path, alert: "Please upload your CV in .doc, .docx, .pdf, or .txt format."
    end

    drive = GoogleDrive.get_drive_service

    # First, upload the original file to Google Drive

    original_file = drive.create_file( {name: params[:CV].original_filename},
      fields: 'id',
      # TODO: Not sure that tempfile will always exist here, test with like a tiny tiny file
      upload_source: params[:CV].tempfile,
      content_type: mime_type
    )

    # Second, make a copy of the file, converting it to a Google Doc

    gdoc_file = Google::Apis::DriveV3::File.new
    gdoc_file.name = "#{params[:CV].original_filename}_google_doc_import"
    gdoc_file.mime_type = 'application/vnd.google-apps.document'
    gdoc_file = drive.copy_file original_file.id, gdoc_file

    # Third, obtain the full text of the file from the Docs export

    cv_text = drive.export_file(gdoc_file.id, 'text/plain',download_dest: StringIO.new)

    # Finally, save all of our gains:

    profile = current_user.mentor_match_profile

    profile.original_cv_drive_id = original_file.id
    profile.cv_gdoc_drive_id = gdoc_file.id
    profile.cv_text = cv_text.string

    profile.save!

    redirect_to mentor_match_path, notice: "Resume uploaded successfully!"




  end

  private

  def set_mentor_match_profile
    @mentor_match_profile = current_user.mentor_match_profile
  end

  def mentor_match_profile_params
    params.require(:mentor_match_profile).permit(:match_role, :position, :seeking_summary)
  end
  
end
