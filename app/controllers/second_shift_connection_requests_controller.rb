class SecondShiftConnectionRequestsController < ApplicationController

  include ConnectionRequestActions

  layout "second_shift_pages"

  def index
    @connection_requests = ConnectionRequest
    .where(initiator: current_user).or(ConnectionRequest.where(receiver: current_user, initiator_status: 'created'))
    .where(connection_type: 'second_shift')
    .order(created_at: :desc)
    .page(params[:page])

    render 'connection_requests/index'
  end

  def create
    @connection_request = ConnectionRequest.new(connection_request_params)
    @connection_request.initiator = current_user
    @connection_request.receiver = @connection_request.receiver_service_posting.user
    @connection_request.request_type = 'second_shift'

    if @connection_request.save
      redirect_to @connection_request.show_path, notice: 'Connection request sent.'
    else
      render :new
    end
  end



  private

  def connection_request_params
    params.require(:connection_request).permit(:initiator_service_posting_id, :receiver_service_posting_id)
  end

end
