
class MailerJob

  def initialize (user)
    @user_id = user.id
  end

  def deliver
    SimplerMailer.welcome_email(User.find(@user_id)).deliver
  end


  handle_asynchronously :deliver





end