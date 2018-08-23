class CreateVendorReviewLikes < ActiveRecord::Migration[5.2]
  def change
    create_table :vendor_review_likes do |t|
      t.references :user, foreign_key: true
      t.references :vendor_review, foreign_key: true

      t.timestamps
    end
  end
end
