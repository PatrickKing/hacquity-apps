class MentorMatchPagesController < ApplicationController

  before_action :require_login

  before_action :ensure_profile

  def main
    @mentor_match_profile = current_user.mentor_match_profile
  end


  def ensure_profile
    if current_user.mentor_match_profile.nil?
      profile = MentorMatchProfile.create user: current_user
      current_user.mentor_match_profile = profile
    end
  end

end
