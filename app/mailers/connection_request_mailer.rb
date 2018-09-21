class ConnectionRequestMailer < ApplicationMailer

  def connection_requested (connection_request)
    @connection_request = connection_request

    # If this user has sent a connection request to the recipient in the last week, we skip this email to prevent spamming them.
    recent_connection_requests = ConnectionRequest.where(initiator_id: connection_request.initiator.id,
        receiver_id: connection_request.receiver.id)
      .where("created_at > :seven_days_ago", seven_days_ago: 7.days.ago)
      .where("id <> :id", id: connection_request.id)
    return if recent_connection_requests.any?

    case connection_request.connection_type
    when 'second_shift'
      @connections_url = ss_connection_requests_url
      @detail = "#{connection_request.initiator.name} wants to connect about your posting named '#{connection_request.receiver_service_posting.summary}'."
    when 'mentor_match'
      @connections_url = mm_connection_requests_url
      @detail = "#{connection_request.initiator.name} wants to connect about your Mentor Match profile."
    end

    mail to: "#{@connection_request.receiver.name} <#{@connection_request.receiver.email}>" , subject: "#{connection_request.initiator.name} wants to connect on DoM Citizen."
  end

end
