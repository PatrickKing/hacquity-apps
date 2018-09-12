
require './app/models/concerns/GoogleDrive'

class MentorMatchProfilesController < ApplicationController

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
    # To avoid making all CV files on gdrive public, the app acts as an authenticating proxy here. Requests for CV files are made by the user to this endpoint, and from here to gdrive, and not directly from the user's client to gdrive.
    # This is a lot less efficient than letting the user request the files directly, and gdrive DOES have great authentication/permission features... but then we'd need all our user accounts to be google accounts. This would be a GREAT future feature but has huge ramifications!

    if @mentor_match_profile.original_cv_drive_id.nil?
      redirect_to request.referrer || @mentor_match_profile
      return
    end

    drive = GoogleDrive.get_drive_service
    file_data = StringIO.new

    # NB: this call does NOT return a DriveV3::File, it returns the StringIO instance. gdrive is weird ¯\_(ツ)_/¯
    drive.get_file @mentor_match_profile.original_cv_drive_id, download_dest: file_data

    send_data file_data.string,
    filename: @mentor_match_profile.original_cv_file_name,
    type: @mentor_match_profile.original_cv_mime_type

    # TODO: if this were a node app, the file data request would be async, and the data return would be async, the whole thing would be nonblocking... can rails let us do anything similar here?

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
