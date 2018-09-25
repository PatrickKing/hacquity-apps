class AdminCvsController < ApplicationController

  include CvHelper

  before_action :require_admin_login
  before_action :set_user, only: [:edit, :update]

  layout 'admin_pages'

  def index
    # TODO: someday, find users by search search
    @users = User.order(name: :asc).page(params[:page]).per(102).includes(:mentor_match_profile)
  end

  def edit
  end

  def update
    upload_cv_via_form edit_admin_cv_path(@user), @user
  end

  def edit_bulk
    
  end

  def update_bulk
    
  end

  protected

  def set_user
    @user = User.includes(:mentor_match_profile).find(params[:id])
  end

end
