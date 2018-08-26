class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :service_postings
  has_one :mentor_match_profile

  has_many :initiator_connection_requests,
    class_name: 'ConnectionRequest',
    foreign_key: :initiator_id

  has_many :receiver_connection_requests,
    class_name: 'ConnectionRequest',
    foreign_key: :receiver_id


  validates :name, presence: true
  validates :name, length: { maximum: 300 }

  # TODO: this may be too expensive to query up all the time, may wish to store and update a counter on the user in the future.
  def active_connection_request_count
    ConnectionRequest.where("""
      (initiator_id = :user_id OR receiver_id = :user_id) AND
      (resolved = false)""", user_id: self.id)
    .count
  end

  before_create do
    self.second_shift_enabled = false if self.second_shift_enabled.nil?
    self.mentor_match_enabled = false if self.mentor_match_enabled.nil?
  end

end
