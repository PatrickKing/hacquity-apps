require './app/controllers/concerns/cv_helper'


class MyCvsController < ApplicationController

  include CvHelper

  before_action :require_login

  layout "cv_catalogue_pages"


  def edit
    
  end

  def update_cv
    handle_cv_upload edit_my_cv_path
  end

end