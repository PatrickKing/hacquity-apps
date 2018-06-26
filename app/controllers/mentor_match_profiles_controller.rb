
require './app/models/concerns/GoogleDrive'

class MentorMatchProfilesController < ApplicationController
  before_action :set_mentor_match_profile, only: [:show]

  layout "mentor_match_pages"


  def index
    @mentor_match_profiles = MentorMatchProfile.all
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

    profile_ids = drive_file_list.files.map do |file|
      file.id
    end

    @mentor_match_profiles = MentorMatchProfile.where(original_cv_drive_id: profile_ids)
      .page(params[:page])

  end



  private

  def set_mentor_match_profile
    @mentor_match_profile = MentorMatchProfile.find(params[:id])
  end

end
