class AdminUsersController < ApplicationController
  # That is, the controller that admins will use to manage ordinary users

  before_action :require_admin_login

  layout 'admin_pages'

  helper_method :users_to_confirm

  def new
    @user = User.new
  end

  def create

    @user = User.new user_params

    # Initialize the user's password to something unguessable
    @user.password = SecureRandom.urlsafe_base64(16)
    # Since this user was invited by an admin, we consider them approved.
    @user.admin_approved = DateTime.now
    # Similarly, since this is not someone on the internet claiming they have an email address, but an admin offering access to an email address, no sense in making the user confirm ownership.
    @user.confirmed_at = DateTime.now

    if @user.save
      redirect_to new_admin_user_path, notice: "User #{@user.name} <#{@user.email}> was invited."
      # TODO: yes, we're calling a protected devise method here. It seems to work fine but this is not ideal.
      raw_token = @user.send :set_reset_password_token
      InvitedUserPasswordChangeJob.new(@user, raw_token).deliver
      @user.send_cv_submission_mail
    else
      render :new
    end

  end

  def approve_index
    # Include recently approved users so that items do not disappear from the list in the middle of use.
    # We're going to use little inline forms which cause a turbolinks page refresh, this combined with a stable list of users gives the impression of using a single page application with no client side code :3
    @users = User.where('admin_approved is NULL or admin_approved > :three_days_ago', three_days_ago: 3.days.ago)
      .order(created_at: :desc)
      .page(params[:page])
  end

  def approve
    user = User.find params[:admin_user_id]

    user.admin_approved = DateTime.now
    user.save!
    redirect_to approve_index_admin_users_path(page: params[:page])

    NotifyUserAccountApprovedJob.new(user).deliver
  end

  def disable_index
    # TODO: would be a nicer UX to be able to search for users, but there won't be that many to start, and browsers have ctrl+f
    # 102, because users are displayed 3 per row, and this gives us a clean last row :3
    @users = User.order(name: :asc).page(params[:page]).per(102)
  end

  def disable
    user = User.find params[:admin_user_id]
    user.admin_disabled = DateTime.now
    user.save!
    redirect_to disable_index_admin_users_path(page: params[:page])
  end

  def reenable
    user = User.find params[:admin_user_id]
    user.admin_disabled = nil
    user.save!
    redirect_to disable_index_admin_users_path(page: params[:page])
  end


  protected


  def user_params
    params.require(:user).permit([:name, :email])
  end


  def users_to_confirm
    User.where('admin_approved is NULL')
  end

end
