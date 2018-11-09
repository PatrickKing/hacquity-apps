class ApplicationController < ActionController::Base

  protected

  def require_login
    if not user_signed_in? and not admin_signed_in?
      redirect_to root_path
    end
  end

  def require_admin_login
    if not admin_signed_in?
      redirect_to root_path
    end
    
  end

  def require_user_login
    if not user_signed_in?
      redirect_to root_path
    end
    
  end

end
