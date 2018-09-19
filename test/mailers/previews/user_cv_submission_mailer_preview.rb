# Preview all emails at http://localhost:3000/rails/mailers/user_cv_submission_mailer
class UserCvSubmissionMailerPreview < ActionMailer::Preview

  def cv_submission_welcome
    @user = User.first

    UserCvSubmissionMailer.cv_submission_welcome @user
  end

end
