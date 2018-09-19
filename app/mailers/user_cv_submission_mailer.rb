class UserCvSubmissionMailer < ApplicationMailer

  default from: ENV['CV_SUBMISSION_EMAIL']

  def cv_submission_welcome (user)
    @user = user

    mail to: user.email, subject: "Share your CV on DoM Citizen"
  end
end
