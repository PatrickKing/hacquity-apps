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

  def seeking_summary
    "#{self.full_time_equivalents} FTE #{self.service_type}"
  end

  before_create do
    self.closed = false if self.closed.nil?
  end


end
