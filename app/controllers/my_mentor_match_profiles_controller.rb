
require './app/models/concerns/GoogleDrive'
require './app/controllers/concerns/cv_helper'

class MyMentorMatchProfilesController < ApplicationController
  
  include CvHelper

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
    handle_cv_upload my_mentor_match_profile_path
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
