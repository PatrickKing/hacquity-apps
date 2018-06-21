class ServicePosting < ApplicationRecord

  ServicePosting::ServiceTypes = [
    'Nanny',
    'Meal Preparation',
    'Housekeeping',
    'Driving',
    'Childcare',
    'Eldercare',
    'Errands',
    'Other'
  ]

  belongs_to :user

  has_many :initiator_connection_requests,
    class_name: 'ConnectionRequest',
    foreign_key: :initiator_service_posting_id

  has_many :receiver_connection_requests,
    class_name: 'ConnectionRequest',
    foreign_key: :receiver_service_posting_id


  validates :summary, presence: true
  validates :summary, length: { maximum: 300 }

  validates :posting_type, presence: true
  validates :posting_type, inclusion: {in: ['Wanted', 'Available']}

  validates :service_type, presence: true
  validates :service_type, inclusion: {in: ServicePosting::ServiceTypes }

  validates :full_time_equivalents, presence: true
  validates :full_time_equivalents, numericality: {greater_than: 0, less_than_or_equal_to: 1}

  validates :description, length: { maximum: 50000 }



  def open_closed_text
    if self.closed then 'Closed' else 'Open' end
  end

  def full_seeking_summary
    "#{self.posting_type}: #{self.full_time_equivalents} FTE #{self.service_type}"
  end

  def seeking_summary
    "#{self.full_time_equivalents} FTE #{self.service_type}"
  end


  def full_matches

    query_posting_type = if self.posting_type == 'Wanted' then 'Available' else'Wanted' end

    time_operand = if self.posting_type == 'Available' then '<=' else '>=' end

    ServicePosting.where(
      closed: false,
      service_type: self.service_type,
      posting_type: query_posting_type)
    .where("full_time_equivalents #{time_operand} ?", self.full_time_equivalents)
    .where("id <> ?", self.id)
    .where("user_id <> ?", self.user.id)
    .order(full_time_equivalents: :desc)

  end

  def best_matches
    self.full_matches.limit(3)
  end


  def connection_exists? (service_posting)
    return true if ConnectionRequest.where(initiator_service_posting: self, receiver_service_posting: service_posting).any?
    return true if ConnectionRequest.where(initiator_service_posting: service_posting, receiver_service_posting: self).any?
    false
  end

  def connection (service_posting)
    request = nil

    request = ConnectionRequest.where(initiator_service_posting: self, receiver_service_posting: service_posting).first
    return request if request

    request = ConnectionRequest.where(initiator_service_posting: service_posting, receiver_service_posting: self).first
    request
  end

  before_validation do
    self.closed = false if self.closed.nil?
  end


end
