class MentorMatchPagesController < ApplicationController

  before_action :require_login

  def main
    @mentor_match_profile = current_user.mentor_match_profile
  end

end
