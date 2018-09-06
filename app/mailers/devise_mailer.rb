
class DeviseMailer < Devise::Mailer

  add_template_helper(MailHelper)

end