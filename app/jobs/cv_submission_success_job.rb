
class CvSubmissionSuccessJob

  def initialize (user)
    @user_id = user.id
  end

  def deliver
    UserCvSubmissionMailer.cv_submission_success(User.find(@user_id)).deliver
  end

  handle_asynchronously :deliver

end