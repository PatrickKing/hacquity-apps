class SimplerMailer < ApplicationMailer

  def welcome_email (user)
    @myvar = 'erro warudo'
    @user = user

    mail to: 'patrick.f.king@gmail.com', subject: 'Welcome to My Awesome Site'
  end

end
