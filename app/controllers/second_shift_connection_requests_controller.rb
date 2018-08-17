class SecondShiftConnectionRequestsController < ApplicationController

  include ConnectionRequestActions

  layout "second_shift_pages"

  def index

    recent_resolved_requests = ConnectionRequest.where(resolved: true)
      .where("updated_at >= :date_limit", date_limit: 3.days.ago)

    @connection_requests = ConnectionRequest.where(initiator: current_user)
      .or(ConnectionRequest.where(receiver: current_user))
      .where(resolved: false).or(recent_resolved_requests)
      .where(connection_type: 'second_shift')
      .order(created_at: :desc)
      .page(params[:page])

    render 'connection_requests/index'
  end

  def create
    # In the unlikely event that someone clicks to create a connection after one has been created:

    @connection_request = ConnectionRequest.new(connection_request_params)
    @connection_request.initiator = current_user
    @connection_request.receiver = @connection_request.receiver_service_posting.user
    @connection_request.connection_type = 'second_shift'

    current_connection = ConnectionRequest.current_connection_request(@connection_request.initiator, @connection_request.receiver)
    if current_connection
      redirect_to redirection_path, notice: 'Connection request already exists.'
      return
    end

    if @connection_request.save
      redirect_to redirection_path, notice: 'Connection request sent.'
    else
      redirect_to service_posting_path(@connection_request.initiator_service_posting), error: 'A problem prevented us from creating the request.'
    end
  end



  private

  def connection_request_params
    params.require(:connection_request).permit(:initiator_service_posting_id, :receiver_service_posting_id)
  end

  def redirection_path
    request.referer || ss_connection_requests_path
  end

end
