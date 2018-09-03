# Preview all emails at http://localhost:3000/rails/mailers/simpler_mailer
class SimplerMailerPreview < ActionMailer::Preview

  def welcome_email
    user = User.first

    SimplerMailer.welcome_email user
  end


end
