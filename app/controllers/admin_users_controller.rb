class AdminUsersController < ApplicationController

  before_action :require_admin_login

  layout 'admin_pages'


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

    ap @user

    if @user.save
      redirect_to new_admin_user_path, notice: "User #{@user.name} <#{@user.email}> was invited."
      raw_token = @user.send :set_reset_password_token
      InvitedUserPasswordChangeJob.new(@user, raw_token).deliver
    else
      render :new
    end


    # random pw
    # admin approved
    # error cases: email taken, no name
    # emails: pw reset, welcome, update cv ... 
    
  end

  def confirm_index
    
  end

  def confirm
    
  end

  def disable_index
    
  end

  def disable
    
  end

  def reenable
    
  end


  protected


  def user_params
    params.require(:user).permit([:name, :email])
  end

end
