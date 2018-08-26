
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

      drive = GoogleDrive.get_drive_service

      # TODO: technically, we could make the old CV as not searchable and then 
      # encounter an error uploading the new one. A proper app would need to
      # address this.
      unless @mentor_match_profile.original_cv_drive_id.nil?
        previous_cv = drive.get_file @mentor_match_profile.original_cv_drive_id

        # Yes, that trailing {} is required, or the hash will be treated as a set of keyword arguments.
        drive.update_file(previous_cv.id, {properties: {"seeking"=>@mentor_match_profile.seeking?}}, {})
      end

      redirect_to my_mentor_match_profile_path, notice: 'Mentor match profile was successfully updated.'
    else
      render :edit
    end
  end

  def edit_cv
    
  end

  def update_cv
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
    profile = current_user.mentor_match_profile

    # TODO: technically, we could make the old CV as not searchable and then 
    # encounter an error uploading the new one. A proper app would need to
    # address this.
    unless profile.original_cv_drive_id.nil?
      # previous_cv = drive.get_file profile.original_cv_drive_id
      drive.update_file(profile.original_cv_drive_id, {properties: {"seeking"=>"false"}}, {})
    end



    # Upload the file to Google Drive


    original_file = drive.create_file( {name: params[:CV].original_filename, properties: {"seeking"=>"true"}
      },
      fields: 'id,web_view_link',
      # TODO: Not sure that tempfile will always exist here, test with like a tiny tiny file
      # Update: have never seen the upload break at this point, assume this is OK.
      upload_source: params[:CV].tempfile,
      content_type: mime_type
    )

    perm = Google::Apis::DriveV3::Permission.new
    perm.role = 'reader'
    perm.type = 'anyone'
    drive.create_permission(original_file.id, perm, {}) 


    # Finally, save our gains:

    profile.original_cv_drive_id = original_file.id
    profile.web_view_link = original_file.web_view_link
    profile.save!

    redirect_to my_mentor_match_profile_path, notice: "CV uploaded successfully!"
  end





  private

  def set_mentor_match_profile
    @mentor_match_profile = current_user.mentor_match_profile
  end

  def mentor_match_profile_params
    params.require(:mentor_match_profile).permit(:match_role, :position, :seeking_summary)
  end

end
