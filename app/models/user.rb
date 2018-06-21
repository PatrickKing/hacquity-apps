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

  before_create do
    self.second_shift_enabled = false if self.second_shift_enabled.nil?
    self.mentor_match_enabled = false if self.mentor_match_enabled.nil?
  end

end
