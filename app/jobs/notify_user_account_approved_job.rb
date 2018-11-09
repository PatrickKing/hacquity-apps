class NotifyUserAccountApprovedJob

  def initialize (user)
    @user_id = user.id
  end

  def deliver
    UserMailer.notify_user_account_approved(User.find(@user_id)).deliver
  end

  handle_asynchronously :deliver

end
