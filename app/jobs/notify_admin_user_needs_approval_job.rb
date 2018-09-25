class NotifyAdminUserNeedsApprovalJob

  def initialize (admin, user)
    @admin_id = admin.id
    @user_id = user.id
  end

  def deliver
    AdminMailer.notify_admin_user_needs_approval(Admin.find(@admin_id), User.find(@user_id)).deliver
  end

  handle_asynchronously :deliver

end
