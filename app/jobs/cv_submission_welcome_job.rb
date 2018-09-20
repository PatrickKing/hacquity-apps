
class CvSubmissionWelcomeJob

  def initialize (user)
    @user_id = user.id
  end

  def deliver
    UserCvSubmissionMailer.cv_submission_welcome(User.find(@user_id)).deliver
  end

  handle_asynchronously :deliver

end