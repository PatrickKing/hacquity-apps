class VendorReviewLike < ApplicationRecord
  belongs_to :vendor_review
  belongs_to :user
end
