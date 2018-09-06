class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, 
         :lockable, :confirmable

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

  def email_subscription_string
    if subscribe_to_emails
      'Subscribed to email'
    else
      'No email'
    end
  end

  def send_devise_notification (notification, *args)
    DeviseMailerJob.new(notification, self, *args).deliver
  end

  # devise_mailer is a protected method on the user instance, so we can't call it from my delayed_job instance directly. Hence this song and dance.
  def deliver_now (notification, args)
    devise_mailer.send(notification, self, *args).deliver
  end

  before_create do
    self.second_shift_enabled = false if self.second_shift_enabled.nil?
    self.mentor_match_enabled = false if self.mentor_match_enabled.nil?
    self.subscribe_to_emails = true if self.subscribe_to_emails.nil?
    self.unsubscribe_token = SecureRandom.urlsafe_base64(16) if self.unsubscribe_token.nil?
  end

end
