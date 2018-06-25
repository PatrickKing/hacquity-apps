class MentorMatchProfilesController < ApplicationController
  before_action :set_mentor_match_profile, only: [:show]

  def index
    @mentor_match_profiles = MentorMatchProfile.all
  end

  def show
  end


  # Custom non-restful actions:

  def search
    
  end



  private

  def set_mentor_match_profile
    @mentor_match_profile = MentorMatchProfile.find(params[:id])
  end

end
