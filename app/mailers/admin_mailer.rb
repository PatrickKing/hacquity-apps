class AdminMailer < ApplicationMailer

  def notify_admin_user_needs_approval (admin, user)
    @admin = admin
    @user = user

    mail to: "#{admin.name} <#{admin.email}>", subject: "New user signup for approval: #{user.name}"
  end

end
