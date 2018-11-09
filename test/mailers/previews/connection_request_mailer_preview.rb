# Preview all emails at http://localhost:3000/rails/mailers/connection_request_mailer
class ConnectionRequestMailerPreview < ActionMailer::Preview

  def connection_requested
    
    connection_request = ConnectionRequest.first

    ConnectionRequestMailer.connection_requested connection_request
  end

end
