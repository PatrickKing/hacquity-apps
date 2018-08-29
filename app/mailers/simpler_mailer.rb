class SimplerMailer < ApplicationMailer

  default from: 'notifications@example.com'

  def welcome_email (user)
    @myvar = 'erro warudo'
    @user = user

    mail to: 'patrick.f.king@gmail.com', subject: 'Welcome to My Awesome Site'
  end

end
