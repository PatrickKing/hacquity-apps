class SecondShiftConnectionRequestsController < ApplicationController

  include ConnectionRequestActions

  layout "second_shift_pages"

  def index
    @connection_requests = ConnectionRequest
    .where(initiator: current_user).or(ConnectionRequest.where(receiver: current_user, initiator_status: 'created'))
    .order(created_at: :desc)
    .page(params[:page])
  end

  def create
    @connection_request = ConnectionRequest.new(connection_request_params)
    @connection_request.initiator = current_user
    @connection_request.receiver = @connection_request.receiver_service_posting.user
    @connection_request.request_type = 'second_shift'

    if @connection_request.save
      redirect_to @connection_request, notice: 'Connection request sent.'
    else
      render :new
    end
  end

  def backup_redirect_path
    ss_connection_requests_path
  end


  private

  def connection_request_params
    params.require(:connection_request).permit(:initiator_service_posting_id, :receiver_service_posting_id)
  end

end
