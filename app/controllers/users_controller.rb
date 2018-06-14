class UsersController < ApplicationController

  before_action :require_login

  def activate_second_shift
    current_user.second_shift_enabled = true
    current_user.save!
    redirect_to second_shift_path
  end

  def activate_mentor_match
    current_user.mentor_match_enabled = true
    current_user.save!
    redirect_to mentor_match_path
  end

end