class MentorMatchConnectionRequestsController < ApplicationController

  def create
    @connection_request = ConnectionRequest.new(connection_request_params)

    if @connection_request.save
      redirect_to @connection_request, notice: 'Connection request was successfully created.'
    else
      render :new
    end
  end


  private
  
  def connection_request_params
    params.require(:connection_request).permit( :receiver_id, :initiator_service_posting_id, :receiver_service_posting_id, :connection_type)
  end
end
