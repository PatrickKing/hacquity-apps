class MentorMatchConnectionRequestsController < ApplicationController

  include ConnectionRequestActions

  before_action :require_user_login

  layout 'mentor_match_pages'

  def index

    @connection_requests = index_connection_requests

    render 'connection_requests/index'
  end


  def create

    @connection_request = ConnectionRequest.new connection_request_params
    @connection_request.initiator = current_user

    @connection_request.connection_type = 'mentor_match'

    # In the unlikely event that someone clicks to create a connection after one has been created:
    # TODO would be nice to extract + deduplicate this, but it needs to have the caller return early... not sure how I want to do this
    current_connection = ConnectionRequest.current_connection_request(@connection_request.initiator, @connection_request.receiver)
    if current_connection
      redirect_to redirection_path, notice: 'Connection request already exists.'
      return
    end

    if @connection_request.save
      redirect_to redirection_path, notice: 'Connection request sent.'
      if @connection_request.receiver.subscribe_to_emails
        ConnectionRequestMailerJob.new(@connection_request).deliver
      end
    else
      redirect_to redirection_path, alert: 'A problem prevented us from creating the request.'
    end
  end




  private
  
  def connection_request_params
    params.require(:connection_request).permit(:receiver_id)
  end

  def redirection_path
    request.referer || mm_connection_requests_path
  end

end
