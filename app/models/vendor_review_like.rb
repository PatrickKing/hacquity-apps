class VendorReviewLike < ApplicationRecord
  belongs_to :vendor_review
  belongs_to :user

  # This record has evolved from simply a reflecting a 'like' to storing a value of how helpful the user found the review.

  # -1 signifying unhelpful, 0 neutral, 1 helpful
  validates :helpfulness, inclusion: {in: [-1, 0, 1]}

  before_validation do
    self.helpfulness = 0 if self.helpfulness.nil?
  end


end
