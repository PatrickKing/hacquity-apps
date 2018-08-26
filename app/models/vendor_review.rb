class VendorReview < ApplicationRecord

  scope :search, -> (query) {
    where('text_search_document @@ to_tsquery(:query)', query: query)
  }

  belongs_to :user

  has_many :vendor_review_likes, dependent: :delete_all

  validates :title, presence: true
  validates :title, length: { maximum: 300 }

  validates :vendor_name, presence: true
  validates :vendor_name, length: { maximum: 300 }
  
  validates :vendor_services, presence: true
  validates :vendor_services, length: { maximum: 300 }

  validates :body, presence: true
  validates :body, length: { maximum: 50000 }

  validates :vendor_address_line1, length: { maximum: 300 }
  validates :vendor_address_line2, length: { maximum: 300 }
  validates :vendor_email_address, length: { maximum: 300 }
  validates :vendor_phone_number, length: { maximum: 20 }
  validates :vendor_contact_instructions, length: { maximum: 300 }

  validates :likes, numericality: {greater_than_or_equal_to: 0}

  def has_contact_information?
    !(self.vendor_address_line1.blank? and
      self.vendor_address_line2.blank? and
      self.vendor_email_address.blank? and
      self.vendor_phone_number.blank? and
      self.vendor_contact_instructions.blank?)
  end

  def liked_by? (user)
    like = self.vendor_review_likes.where user_id: user.id
    not like.empty?
  end

  def short_body
    shortened_body = self.body.split(' ')[0...10].join(' ')

    if shortened_body == self.body
      shortened_body
    else
      shortened_body.concat(' ...')
    end

  end

  before_validation do
    self.likes = 0 if self.likes.nil?
  end



end
