# Preview all emails at http://localhost:3000/rails/mailers/devose_mailer
class DeviseMailerPreview < ActionMailer::Preview

  def confirmation_instructions
    user = User.first
    token = 'foobarbaz'
    DeviseMailer.send :confirmation_instructions, user, token: token
  end

  # NB: Unused for now
  # def email_changed
  # end

  def password_change
    user = User.first
    DeviseMailer.send :password_change, user
  end

  def reset_password_instructions
    user = User.first
    token = 'foobarbaz'
    DeviseMailer.send :reset_password_instructions, user, token: token
  end

  def unlock_instructions
    user = User.first
    token = 'foobarbaz'
    DeviseMailer.send :unlock_instructions, user, token: token
  end

end
