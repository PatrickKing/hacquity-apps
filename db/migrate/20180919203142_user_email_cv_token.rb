class UserEmailCvToken < ActiveRecord::Migration[5.2]
  def change

    add_column :users, :cv_receipt_token, :string

    User.all.each do |user|
      user.cv_receipt_token = SecureRandom.urlsafe_base64(16)
      user.save! validate: false
    end

  end
end
