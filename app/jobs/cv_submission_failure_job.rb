
class CvSubmissionFailureJob

  def initialize (user, message)
    @user_id = user.id
    @message = message
  end

  def deliver
    UserCvSubmissionMailer.cv_submission_failure(User.find(@user_id), @message).deliver
  end

  handle_asynchronously :deliver

end