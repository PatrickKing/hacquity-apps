class MentorMatchProfilesController < ApplicationController
  before_action :set_mentor_match_profile, only: [:show, :edit, :update, :destroy]

  # GET /mentor_match_profiles
  # def index
  #   @mentor_match_profiles = MentorMatchProfile.all
  # end

  # GET /mentor_match_profiles/1
  def show
  end

  # # GET /mentor_match_profiles/new
  # def new
  #   @mentor_match_profile = MentorMatchProfile.new
  # end

  # # GET /mentor_match_profiles/1/edit
  # def edit
  # end

  # # POST /mentor_match_profiles
  # def create
  #   @mentor_match_profile = MentorMatchProfile.new(mentor_match_profile_params)

  #   if @mentor_match_profile.save
  #     redirect_to @mentor_match_profile, notice: 'Mentor match profile was successfully created.'
  #   else
  #     render :new
  #   end
  # end

  # # PATCH/PUT /mentor_match_profiles/1
  # def update
  #   if @mentor_match_profile.update(mentor_match_profile_params)
  #     redirect_to @mentor_match_profile, notice: 'Mentor match profile was successfully updated.'
  #   else
  #     render :edit
  #   end
  # end

  # # DELETE /mentor_match_profiles/1
  # def destroy
  #   @mentor_match_profile.destroy
  #   redirect_to mentor_match_profiles_url, notice: 'Mentor match profile was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_mentor_match_profile
      @mentor_match_profile = MentorMatchProfile.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def mentor_match_profile_params
      params.require(:mentor_match_profile).permit(:user_id, :cv_text, :match_role, :position)
    end
end
