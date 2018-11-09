class ApplicationMailer < ActionMailer::Base
  default from: "DoM Citizen <#{ENV['MAILER_REPLY_TO_ADDRESS']}>"
  add_template_helper(MailHelper)
  layout 'mailer'
end
