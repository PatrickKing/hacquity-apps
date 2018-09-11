
require './app/models/concerns/GoogleDrive'

class MentorMatchProfilesController < ApplicationController

  before_action :require_login

  before_action :set_mentor_match_profile, only: [:show, :cv]

  layout "mentor_match_pages"


  def index
    @mentor_match_profiles = MentorMatchProfile.where.not(match_role: 'Not Seeking')
      .page(params[:page])
  end

  def show
  end


  # Custom non-restful actions:

  def search

    if params[:query].blank?
      @mentor_match_profiles = MentorMatchProfile.none
      return
    end

    # A very basic injection prevention as the query is quoted
    # TODO: we might want to do something more aggressive here. I'm not exactly
    # sure how to escape google query strings properly
    query = params[:query].gsub "'", ''

    drive = GoogleDrive.get_drive_service


    drive_file_list = drive.list_files q: "fullText contains '#{query}' and properties has {key='seeking' and value='true'}"

    drive_file_ids = drive_file_list.files.map do |file|
      file.id
    end

    @mentor_match_profiles = MentorMatchProfile.where("original_cv_drive_id IN (:drive_file_ids) OR user_keywords_gdoc_id IN (:drive_file_ids)", drive_file_ids: drive_file_ids)
      .page(params[:page])

  end

  def query
    redirect_to search_mentor_match_profiles_path(query: params[:query])
  end

  def cv
    # To avoid making all CV files on gdrive public, the app acts as an authenticating proxy here. Requests for CV files are made by the user to this endpoint, and from here to gdrive, and not directly from the user's client to gdrive.
    # This is a lot less efficient than letting the user request the files directly, and gdrive DOES have great authentication/permission features... but then we'd need all our user accounts to be google accounts. This would be a GREAT future feature but has huge ramifications!

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

end
