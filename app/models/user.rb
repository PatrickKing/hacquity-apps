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


  User::ContactMethods = [
    'email',
    'phone',
    'text',
    'email_admin',
    'phone_admin', 
    'text_admin'
  ]

  validates :name, presence: true
  validates :name, length: { maximum: 300 }

  validates :preferred_contact_method, inclusion: {in: User::ContactMethods }

  validates :phone_number, length: { maximum: 20 }
  validates :phone_number, presence: true, if: :require_phone_number?

  validates :admin_assistant_name, length: { maximum: 300 }
  validates :admin_assistant_name, presence: true, if: :require_admin_name?

  validates :admin_assistant_email, length: { maximum: 100 }
  validates :admin_assistant_email, presence: true, if: :require_admin_email?

  validates :admin_assistant_phone_number, length: { maximum: 20 }
  validates :admin_assistant_phone_number, presence: true, if: :require_admin_phone_number?


  def require_phone_number?
    ['phone', 'text'].include? self.preferred_contact_method
  end

  def require_admin_phone_number?
    ['phone_admin', 'text_admin'].include? self.preferred_contact_method
  end

  def require_admin_email?
    self.preferred_contact_method == 'email_admin'
  end

  def require_admin_name?
    ['email_admin', 'phone_admin', 'text_admin'].include? self.preferred_contact_method
  end


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

  def send_cv_submission_mail (options = {user_requested: false})
    return if not self.subscribe_to_emails and not options[:user_requested]
    CvSubmissionWelcomeJob.new(self).deliver
  end

  # devise_mailer is a protected method on the user instance, so we can't call it from my delayed_job instance directly. Hence this song and dance.
  def deliver_now (notification, args)
    devise_mailer.send(notification, self, *args).deliver
  end

  # This is as big a sign as ever that these two models should actually be one model =/
  def create_mentor_match_profile
    if self.mentor_match_profile.nil?
      profile = MentorMatchProfile.new user: self
      profile.save!
    end
  end

  def active_for_authentication?
    super && self.account_active?
  end

  def account_active?
    self.admin_approved and self.admin_disabled.nil?
  end

  def inactive_message
    # Unfortunately, we need to use some Devise implementation details to get this message right. One more place where inheritance falls down.
    return super if self.confirmed_at.nil?
    return :not_admin_approved if self.admin_approved.nil?
    return :account_disabled if self.admin_disabled
    super # handles the 'account locked' case, possibly others
  end

  def notify_admin_to_approve
    return unless self.admin_approved.nil?
    Admin.all.each do |admin|
      NotifyAdminUserNeedsApprovalJob.new(admin, self).deliver
    end
  end

  def after_confirmation
    self.notify_admin_to_approve
    self.send_cv_submission_mail
  end

  before_validation do
    self.second_shift_enabled = false if self.second_shift_enabled.nil?
    self.mentor_match_enabled = false if self.mentor_match_enabled.nil?
    self.subscribe_to_emails = true if self.subscribe_to_emails.nil?
    self.unsubscribe_token = SecureRandom.urlsafe_base64(16) if self.unsubscribe_token.nil?
    self.preferred_contact_method = 'email' if self.preferred_contact_method.blank?
    self.cv_receipt_token = SecureRandom.urlsafe_base64(16) if self.cv_receipt_token.nil?
  end

  after_create :create_mentor_match_profile

end
