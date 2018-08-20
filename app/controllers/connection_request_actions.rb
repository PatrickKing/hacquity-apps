module ConnectionRequestActions

  # NB: when including this module, be sure to define redirection_path

  def self.included(base)
    base.before_action :set_connection_request, only: [:initiator_withdraw, :receiver_accept, :receiver_decline]

    base.before_action :require_initiator, only: [:initiator_withdraw]

    base.before_action :require_receiver, only: [:receiver_accept, :receiver_decline]

    base.before_action :require_not_accepted, only: [:initiator_withdraw, :receiver_accept, :receiver_decline]

  end


  def initiator_withdraw
    @connection_request.initiator_status = 'withdrawn'
    @connection_request.resolved = true
    @connection_request.save!
    flash[:notice] = 'Request withdrawn. The connection request is hidden from the receiving user.'
    redirect_to redirection_path
  end

  def receiver_accept
    @connection_request.receiver_status = 'accepted'
    @connection_request.resolved = true
    @connection_request.save!

    Connection.connect_users @connection_request.receiver, @connection_request.initiator

    flash[:notice] = "Request accepted. You and the initiating user may see each other's emails, send a note to say hello!"
    redirect_to redirection_path

  end

  def receiver_decline
    @connection_request.receiver_status = 'declined'
    @connection_request.resolved = true
    @connection_request.save!
    flash[:notice] = 'Request declined.'
    redirect_to redirection_path
  end

  private

  def index_connection_requests
    ConnectionRequest.where("""
      (initiator_id = :user_id OR receiver_id = :user_id) AND
      ((resolved = false) OR (resolved = true AND updated_at >= :date_limit))
    """, user_id: current_user.id, date_limit: 3.days.ago)
    .order(created_at: :desc)
    .page(params[:page])
  end

  def set_connection_request
    @connection_request = ConnectionRequest.find(params[:id])
  end


  def require_initiator
    if @connection_request.initiator != current_user
      flash[:notice] = 'You need to be the initiator of the request to do that.'
      redirect_to redirection_path
    end
  end

  def require_receiver
    if @connection_request.receiver != current_user
      flash[:notice] = 'You need to be the receiver of the request to do that.'
      redirect_to redirection_path
    end
  end

  def require_not_accepted
    if @connection_request.receiver_status == 'accepted'
      flash[:notice] = 'This connection request has been accepted and can not be changed. Visit the Connections page if you wish to remove this connection.'
      redirect_to redirection_path
    end
  end

end
