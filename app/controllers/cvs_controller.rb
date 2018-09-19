require './app/controllers/concerns/cv_helper'

class CvsController < ApplicationController

  include CvHelper

  helper_method :preserved_params

  before_action :require_login

  before_action :set_mentor_match_profile, only: [:show]

  layout "cv_catalogue_pages"

  def index

    if params[:query].blank?
      @mentor_match_profiles = MentorMatchProfile.none
    else
      # A very basic injection prevention as the query is quoted
      # TODO: we might want to do something more aggressive here. I'm not exactly
      # sure how to escape google query strings properly
      query = params[:query].gsub "'", ''

      drive = GoogleDrive.get_drive_service

      drive_file_list = drive.list_files q: "fullText contains '#{query}'"

      drive_file_ids = drive_file_list.files.map do |file|
        file.id
      end

      @mentor_match_profiles = MentorMatchProfile.where("original_cv_drive_id IN (:drive_file_ids)", drive_file_ids: drive_file_ids)
        .page(params[:page]).includes(:user)
    end

  end

  def show
    respond_with_cv @mentor_match_profile
  end

  def query
    redirect_to cvs_path(preserved_params)
  end

  private

  def preserved_params
    params.permit(:query)
  end

  def set_mentor_match_profile
    @mentor_match_profile = MentorMatchProfile.find(params[:id])
  end



end