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

    if @connection_request.save
      redirect_to @connection_request, notice: 'Connection request sent.'
    else
      render :new
    end
  end


  private

  def connection_request_params
    params.require(:connection_request).permit( :receiver_id, :initiator_service_posting_id, :receiver_service_posting_id, :connection_type)
  end
end
