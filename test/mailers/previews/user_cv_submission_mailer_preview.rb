# Preview all emails at http://localhost:3000/rails/mailers/user_cv_submission_mailer
class UserCvSubmissionMailerPreview < ActionMailer::Preview

  def cv_submission_welcome
    @user = User.first
    UserCvSubmissionMailer.cv_submission_welcome @user
  end

  def cv_submission_success
    @user = User.first
    UserCvSubmissionMailer.cv_submission_success @user
  end

  def cv_submission_failure_no_user
    @email = 'foo@bar.com'
    @message = "I just don't know what went wrong!"
    UserCvSubmissionMailer.cv_submission_failure_no_user @email, @message
  end

  def cv_submission_failure
    @user = User.first
    @message = "I just don't know what went wrong!"
    UserCvSubmissionMailer.cv_submission_failure @user, @message
  end

end
