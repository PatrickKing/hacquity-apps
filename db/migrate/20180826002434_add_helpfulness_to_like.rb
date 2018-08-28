class AddHelpfulnessToLike < ActiveRecord::Migration[5.2]
  def change
    add_column :vendor_review_likes, :helpfulness, :integer
  end
end
