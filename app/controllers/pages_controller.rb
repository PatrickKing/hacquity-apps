class PagesController < ApplicationController

  def main
    if user_signed_in?
      redirect_to dashboard_path
    end
    
  end

  def dashboard
    unless user_signed_in?
      redirect_to root_path
    end
    
  end


end
