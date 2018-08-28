class ConnectionRequest < ApplicationRecord

  ConnectionRequest::RequestTypes = [
    'second_shift',
    'mentor_match'
  ]

  ConnectionRequest::InitiatorStatuses = [
    'created',
    'withdrawn'
  ]

  ConnectionRequest::ReceiverStatuses = [
    'awaiting_decision',
    'accepted',
    'declined'
  ]

  belongs_to :initiator, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :initiator_service_posting, class_name: "ServicePosting", optional: true
  belongs_to :receiver_service_posting, class_name: "ServicePosting", optional: true


  validates :initiator, presence: true
  
  validates :receiver, presence: true

  validates :receiver_service_posting, presence: true, if: :is_second_shift_connection?

  validates :connection_type, inclusion: {in: ConnectionRequest::RequestTypes}

  validates :initiator_status, inclusion: {in: ConnectionRequest::InitiatorStatuses}

  validates :receiver_status, inclusion: {in: ConnectionRequest::ReceiverStatuses}


  def is_second_shift_connection?
    self.connection_type == 'second_shift'
  end

  def is_mentor_match_connection?
    self.connection_type == 'mentor_match'
  end

  def accepted?
    self.initiator_status == 'created' and self.receiver_status == 'accepted'
  end

  def initiator_status_string
    if self.initiator_status == 'created' and self.receiver_status == 'accepted'
      "Connection request accepted by #{self.receiver.name}. Send an email to say hello!"
    elsif self.initiator_status == 'created' and self.receiver_status == 'declined'
      "Connection request declined by #{self.receiver.name}"
    elsif self.initiator_status == 'created' and self.receiver_status == 'awaiting_decision'
      'Connection request awaiting recipient reply'
    elsif self.initiator_status == 'withdrawn'
      'Connection request withdrawn by you'
    end
  end


  def receiver_status_string
    if self.initiator_status == 'created' and self.receiver_status == 'accepted'
      "Connection request accepted by you. Send an email to #{self.initiator.name} to say hello!"
    elsif self.initiator_status == 'created' and self.receiver_status == 'declined'
      'Connection request declined by you'
    elsif self.initiator_status == 'created' and self.receiver_status == 'awaiting_decision'
      'Connection request awaiting your reply'
    elsif self.initiator_status == 'withdrawn'
      "Connection request withdrawn by #{self.initiator.name}"
    end
    
  end


  # Regarding the state transitions a connection request is allowed to undergo: once the request is resolved, it is frozen and can no longer be accepted, declined, or withdrawn. Deleting a connection is not a responsibility connection requests.


  def can_be_withdrawn_by? (user)
    return false if self.resolved
    self.initiator == user
  end

  def can_be_accepted_by? (user)
    return false if self.resolved
    self.receiver == user
  end

  def can_be_declined_by? (user)
    return false if self.resolved
    self.receiver == user
  end

  def other_user(user)
    if self.initiator == user
      self.receiver
    elsif self.receiver == user
      self.initiator
    end
  end



  def self.requests_for_users (first_user, second_user)
    forwardRequests = ConnectionRequest.where(initiator: first_user, receiver: second_user)
    reverseRequests = ConnectionRequest.where(initiator: second_user, receiver: first_user)

    forwardRequests.or(reverseRequests).order(updated_at: :desc)
  end

  def self.current_connection_request (first_user, second_user)
    requests_for_users(first_user, second_user).where(resolved: false).first
  end

  def self.old_connection_request (first_user, second_user)
    requests_for_users(first_user, second_user).where(resolved: true).first
  end



  before_validation do
    self.initiator_status ||= 'created'
    self.receiver_status ||= 'awaiting_decision'
    self.resolved = false if self.resolved.nil?
  end

end
