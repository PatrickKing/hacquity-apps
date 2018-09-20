class UserCvSubmissionMailer < ApplicationMailer

  default from: "DoM Citizen <#{ENV['CV_SUBMISSION_EMAIL']}>"

  def cv_submission_welcome (user)
    @user = user

    mail to: "#{user.name} <#{user.email}>", subject: "Share your CV on DoM Citizen"
  end

  def cv_submission_success (user)
    @user = user
    mail to: "#{user.name} <#{user.email}>", subject: "CV Successfully Updated"
  end

  def cv_submission_failure_no_user (email, message)
    @email = email
    @message = message
    mail to: email, subject: "CV Submission Failed"
  end

  def cv_submission_failure (user, message)
    @user = user
    @message = message
    mail to: "#{user.name} <#{user.email}>", subject: "CV Submission Failed"
  end

end
