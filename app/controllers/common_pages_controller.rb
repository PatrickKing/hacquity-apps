class CommonPagesController < ApplicationController

  before_action :require_user_login, except: :main

  def main
    if user_signed_in?
      redirect_to dashboard_path
    elsif admin_signed_in?
      redirect_to admin_dashboard_path
    end
  end

  def dashboard
  end


end
