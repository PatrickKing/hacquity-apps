class CommonPagesController < ApplicationController

  before_action :require_login, except: :main

  def main
    if user_signed_in?
      redirect_to dashboard_path
    end
  end

  def dashboard
  end


end
