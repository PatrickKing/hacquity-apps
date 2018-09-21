
class DeviseMailer < Devise::Mailer

  default from: "DoM Citizen <#{ENV['MAILER_REPLY_TO_ADDRESS']}>"

  add_template_helper(MailHelper)

end