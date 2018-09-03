class ConnectionRequestMailer < ApplicationMailer

  def connection_requested (connection_request)
    @connection_request = connection_request

    case connection_request.connection_type
    when 'second_shift'
      @connections_url = ss_connection_requests_url
      @detail = "#{connection_request.initiator.name} wants to connect about your posting named '#{connection_request.receiver_service_posting.summary}'."
    when 'mentor_match'
      @connections_url = mm_connection_requests_url
      @detail = "#{connection_request.initiator.name} wants to connect about your Mentor Match profile."
    end

    mail to: @connection_request.receiver.email, subject: "#{connection_request.initiator.name} wants to connect on DoM Citizen."
  end

end
