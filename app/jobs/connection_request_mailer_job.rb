
class ConnectionRequestMailerJob

  def initialize (connection_request)
    @connection_request_id = connection_request.id
  end

  def deliver
    ConnectionRequestMailer.connection_requested(ConnectionRequest.find(@connection_request_id)).deliver
  end

  handle_asynchronously :deliver

end