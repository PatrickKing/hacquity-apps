
class InvitedUserPasswordChangeJob

  def initialize (user, token)
    @user_id = user.id
    @token = token
  end

  def deliver
    UserMailer.invited_user_password_change(User.find(@user_id), @token).deliver
  end

  handle_asynchronously :deliver

end