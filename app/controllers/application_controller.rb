class ApplicationController < ActionController::Base

  before_action :require_login

  def require_login
    unless user_signed_in?
      redirect_to root_path
    end
  end

end
