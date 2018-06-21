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
  belongs_to :initiator_service_posting, class_name: "ServicePosting"
  belongs_to :receiver_service_posting, class_name: "ServicePosting"


  validates :initiator, presence: true
  
  validates :receiver, presence: true

  validates :initiator_service_posting, presence: true, if: :is_second_shift_connection?

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
      "Connection accepted by #{self.receiver.name}. Send an email to say hello!"
    elsif self.initiator_status == 'created' and self.receiver_status == 'declined'
      "Connection declined by #{self.receiver.name}"
    elsif self.initiator_status == 'created' and self.receiver_status == 'awaiting_decision'
      'Awaiting recipient reply'
    elsif self.initiator_status == 'withdrawn'
      'Withdrawn by you'
    end
  end


  def receiver_status_string
    if self.initiator_status == 'created' and self.receiver_status == 'accepted'
      "Connection accepted by you. Send an email to #{self.initiator.name} to say hello!"
    elsif self.initiator_status == 'created' and self.receiver_status == 'declined'
      'Connection declined by you'
    elsif self.initiator_status == 'created' and self.receiver_status == 'awaiting_decision'
      'Awaiting your reply'
    end
    
  end

  before_create do
    self.initiator_status ||= 'created'
    self.receiver_status ||= 'awaiting_decision'
  end

  def show_path
    # TODO: this probably belongs someplace else ... 
    if connection_type == 'second_shift'
      Rails.application.routes.url_helpers.ss_connection_request_path self
    elsif connection_type == 'mentor_match'
      Rails.application.routes.url_helpers.mm_connection_request_path self
    end
  end

end
