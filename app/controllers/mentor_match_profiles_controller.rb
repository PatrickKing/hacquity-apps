class MentorMatchProfilesController < ApplicationController

  include CvHelper

  helper_method :preserved_params

  before_action :require_login

  before_action :set_mentor_match_profile, only: [:show, :cv]

  layout "mentor_match_pages"


  def index

    @mentor_match_filter_form = MentorMatchFilterForm.new

    if not params['mentor_match_filter'].nil?
      filter = filter_params
      @mentor_match_filter_form.assign_attributes filter
    end

    profiles = MentorMatchProfile.where.not(match_role: 'Not Seeking')
      .includes(:user)
      .with_availabilities(@mentor_match_filter_form)
      .with_areas(@mentor_match_filter_form)
      .with_tracks(@mentor_match_filter_form)

    if not @mentor_match_filter_form.query.blank?
      # A very basic injection prevention as the query is quoted
      # TODO: we might want to do something more aggressive here. I'm not exactly
      # sure how to escape google query strings properly
      query = @mentor_match_filter_form.query.gsub "'", ''

      drive = GoogleDrive.get_drive_service

      drive_file_list = drive.list_files q: "fullText contains '#{query}' and properties has {key='seeking' and value='true'}"

      drive_file_ids = drive_file_list.files.map do |file|
        file.id
      end

      profiles = profiles.where("original_cv_drive_id IN (:drive_file_ids) OR user_keywords_gdoc_id IN (:drive_file_ids)", drive_file_ids: drive_file_ids)

    end

    @mentor_match_profiles = profiles.page(params[:page])

  end

  def show
  end


  # Custom non-restful actions:

  def query
    new_params = preserved_params
    new_params[:mentor_match_filter] = filter_form_params
    redirect_to mentor_match_profiles_path(new_params)
  end

  def cv
    respond_with_cv @mentor_match_profile
  end

  private

  def set_mentor_match_profile
    @mentor_match_profile = MentorMatchProfile.find(params[:id])
  end


  # NB: intended only for use with params originating from the search + filter FORM and not with the search configuration stored in the URL. Do not add me to preserved params!
  def filter_form_params
    params.require('mentor_match_filter_form').permit(MentorMatchFilterForm::AttributesList)
  end

  # NB: intended only for use with search configuration stored as URL parameters.
  def filter_params
    params.require('mentor_match_filter').permit(MentorMatchFilterForm::AttributesList)
  end

  # Only those parameters which should persist for different renders of the same view. E.g, activating the advanced filters, changing the query + filters, should not affect the other attributes.
  def preserved_params
    params.permit(:query, :show_filters, mentor_match_filter: MentorMatchFilterForm::AttributesList)
  end


end
