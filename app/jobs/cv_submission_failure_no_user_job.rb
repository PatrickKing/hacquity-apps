
class CvSubmissionFailureNoUserJob

  def initialize (email, message)
    @email = email
    @message = message
  end

  def deliver
    UserCvSubmissionMailer.cv_submission_failure_no_user(@email, @message).deliver
  end

  handle_asynchronously :deliver

end