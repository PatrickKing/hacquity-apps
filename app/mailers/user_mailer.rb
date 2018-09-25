class UserMailer < ApplicationMailer

  def invited_user_password_change (user, token)
    @user = user
    @token = token

    mail to: "#{user.name} <#{user.email}>", subject: "Set your DoM Citizen Password"
  end


  def notify_user_account_approved (user)
    @user = user
    
    mail to: "#{user.name} <#{user.email}>", subject: "Your DoM Citizen account is active"
  end


end
