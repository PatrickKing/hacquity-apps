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
      profile = MentorMatchProfile.new user: current_user
      # Validations are for user modifications. Note that the profile is invalid as created, and needs a few fields filled out by the user!
      # TODO: introduce a proper 'first run' wizard when the user joins mentor match.
      profile.save! validate: false
    end

    redirect_to edit_my_mentor_match_profile_path
  end

end