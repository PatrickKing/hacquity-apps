
require './app/models/concerns/GoogleDrive'

class MyMentorMatchProfilesController < ApplicationController
  
  before_action :require_login

  before_action :set_mentor_match_profile, only: [:show, :edit, :update]

  before_action :ensure_profile_search_document, only: :update

  layout "mentor_match_pages"


  def show
  end


  def edit
    @mentor_match_profile_form = MentorMatchProfileForm.new
    @mentor_match_profile_form.assign_attributes @mentor_match_profile.attributes
  end



  def update
    @mentor_match_profile_form = MentorMatchProfileForm.new
    @mentor_match_profile_form.assign_attributes mentor_match_profile_params

    # NB: important to assign the new attrs to the profile before the error conditions are hit, as they are assigned back to the form object if the form isn't valid.
    @mentor_match_profile.assign_attributes mentor_match_profile_params

    unless @mentor_match_profile_form.valid?
      render :edit
      return
    end

    if @mentor_match_profile.save()

      redirect_to my_mentor_match_profile_path, notice: 'Mentor match profile was successfully updated.'

      drive = GoogleDrive.get_drive_service

      # TODO: technically, we could make the old CV as not searchable and then 
      # encounter an error uploading the new one. A proper app would need to
      # address this.
      unless @mentor_match_profile.original_cv_drive_id.nil?
        # Yes, that trailing {} is required, or the hash will be treated as a set of keyword arguments.
        drive.update_file(@mentor_match_profile.original_cv_drive_id, {properties: {"seeking"=>@mentor_match_profile.seeking?}}, {})
      end

      unless @mentor_match_profile.user_keywords_gdoc_id.nil?
        # NB: the drive API actually requires an id, a file object, and a hash of keyword arguments. Making a drive file would require another call, and doesn't seem to be necessary, this particular call with just a hash in place of the file with the attribute I want to adjust seems to work fine!
        strio = StringIO.new(@mentor_match_profile.search_document)

        drive.update_file(@mentor_match_profile.user_keywords_gdoc_id,
          {properties: {"seeking"=>@mentor_match_profile.seeking?}},
          {upload_source: strio, content_type: 'text/plain'})
      end

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

    redirect_to my_mentor_match_profile_path, notice: "CV uploaded successfully!"
  end





  private

  def set_mentor_match_profile
    @mentor_match_profile = current_user.mentor_match_profile
  end

  def mentor_match_profile_params
    params.require(:mentor_match_profile_form).permit(:match_role, :position, :seeking_summary, :available_ongoing, :available_email_questions, :available_one_off_meetings, :career_stage, :user_keywords, :mentorship_opportunities, :mentorship_promotion_tenure, :mentorship_career_life_balance, :mentorship_performance, :mentorship_networking, :career_track_research, :career_track_education, :career_track_policy, :career_track_leadership_admin, :career_track_clinical)
  end

  # Initialize an empty search document if needed, so that it's available for later use.
  def ensure_profile_search_document

    if @mentor_match_profile.user_keywords_gdoc_id.nil?

      drive = GoogleDrive.get_drive_service

      search_document = drive.create_file({
        name: "#{current_user.name}: profile document.",
        properties: {"seeking"=>@mentor_match_profile.seeking?, "dom_citizen_type"=>"profile_document"}
        },
        fields: 'id',
        upload_source: StringIO.new,
        content_type: 'text/plain'
      )

      @mentor_match_profile.user_keywords_gdoc_id = search_document.id
      @mentor_match_profile.save!
    end
    
  end


end
