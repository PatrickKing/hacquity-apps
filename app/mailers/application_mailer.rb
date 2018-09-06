class ApplicationMailer < ActionMailer::Base
  default from: 'patrick.f.king+domcitizen@gmail.com'
  add_template_helper(MailHelper)
  layout 'mailer'
end
