class UsersController < ApplicationController

  before_action :require_login, except: :unsubscribe

  layout 'user_settings_pages'

  def show
  end

  def edit
  end

  def update
    if current_user.update(user_params)
      redirect_to user_path, notice: 'Your info was successfully updated.'
    else
      render :edit
    end
  end


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

  def unsubscribe
    user = User.find_by unsubscribe_token: params[:token]

    if user.nil?
      @message = "We couldn't find your account to unsubscribe you."
      return
    end

    user.subscribe_to_emails = false
    user.save!
    @message = "You have been unsubscribed from DoM Citizen emails."

  end



  def set_email_subscription
    if params[:subscribe] == 'false'
      current_user.subscribe_to_emails = false
      current_user.save!
    elsif params[:subscribe] == 'true'
      current_user.subscribe_to_emails = true
      current_user.save!
    end

    redirect_to user_path
  end

  def user_params
     params.require(:user).permit(:name)
  end

end