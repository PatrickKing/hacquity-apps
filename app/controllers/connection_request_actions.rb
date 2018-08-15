module ConnectionRequestActions

  def self.included(base)
    base.before_action :set_connection_request, only: [:show, :initiator_withdraw, :initiator_undo_withdraw, :receiver_accept, :receiver_decline]

    base.before_action :require_initiator, only: [:initiator_withdraw, :initiator_undo_withdraw]

    base.before_action :require_receiver, only: [:receiver_accept, :receiver_decline]

    base.before_action :require_not_accepted, only: [:initiator_withdraw, :initiator_undo_withdraw, :receiver_accept, :receiver_decline]

  end

  def show
    render 'connection_requests/show'
  end


  def initiator_withdraw
    @connection_request.initiator_status = 'withdrawn'
    @connection_request.save!
    flash[:notice] = 'Request withdrawn. The connection request is hidden from the receiving user.'
    redirect_to @connection_request.show_path
  end
  
  def initiator_undo_withdraw
    @connection_request.initiator_status = 'created'
    @connection_request.save!
    flash[:notice] = 'Request re-enabled. The connection request is visible to the receiving user again.'
    redirect_to @connection_request.show_path
  end

  def receiver_accept
    @connection_request.receiver_status = 'accepted'
    @connection_request.save!

    Connection.create_users @connection_request.receiver, @connection_request.initiator

    flash[:notice] = "Request accepted. You and the initiating user may see each other's emails, send a note to say hello!"
    redirect_to @connection_request.show_path

  end

  def receiver_decline
    @connection_request.receiver_status = 'declined'
    @connection_request.save!
    flash[:notice] = 'Request declined.'
    redirect_to @connection_request.show_path
  end


  private

  def set_connection_request
    @connection_request = ConnectionRequest.find(params[:id])
  end


  def require_initiator
    if @connection_request.initiator != current_user
      flash[:notice] = 'You need to be the initiator of the request to do that.'
      redirect_to @connection_request.show_path
    end
  end

  def require_receiver
    if @connection_request.receiver != current_user
      flash[:notice] = 'You need to be the receiver of the request to do that.'
      redirect_to @connection_request.show_path
    end
  end

  def require_not_accepted
    if @connection_request.receiver_status == 'accepted'
      flash[:notice] = 'This connection request has been accepted and can not be changed. Visit the Connections page if you wish to remove this connection.'
      redirect_to @connection_request.show_path
    end
  end

end
