# Following a recipe on the Devise wiki for multiple login models.
# Not happy that it's here as a rails concern, which is a strange beast, but w.e. I'm just here for the paved cowpath.
# https://github.com/plataformatec/devise/wiki/How-to-Setup-Multiple-Devise-User-Models

module DeviseAccessible

  extend ActiveSupport::Concern

  included do
    before_action :check_user
  end

  protected

  def check_user
    if current_admin
      flash.clear
      # if you have rails_admin. You can redirect anywhere really
      redirect_to root_path && return
    elsif current_user
      flash.clear
      # The authenticated root path can be defined in your routes.rb in: devise_scope :user do...
      redirect_to root_path && return
    end
  end

end