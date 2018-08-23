class CreateVendorReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :vendor_reviews do |t|
      t.references :user, foreign_key: true
      t.integer :likes
      t.string :title
      t.string :body
      t.string :vendor_name
      t.string :vendor_address_line1
      t.string :vendor_address_line2
      t.string :vendor_email_address
      t.string :vendor_phone_number
      t.string :vendor_contact_instructions
      t.string :vendor_services

      t.timestamps
    end
  end
end
