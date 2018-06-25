class UsersController < ApplicationController

  before_action :require_login

  def activate_second_shift
    current_user.second_shift_enabled = true
    current_user.save!
    redirect_to available_service_postings_path
  end

  def activate_mentor_match
    current_user.mentor_match_enabled = true
    current_user.save!

    if current_user.mentor_match_profile.nil?
      MentorMatchProfile.create user: current_user
    end

    redirect_to my_mentor_match_profile_profile_path
  end

end