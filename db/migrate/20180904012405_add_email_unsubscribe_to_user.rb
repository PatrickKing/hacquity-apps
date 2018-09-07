class AddEmailUnsubscribeToUser < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :subscribe_to_emails, :boolean
    add_column :users, :unsubscribe_token, :string
    add_index :users, :unsubscribe_token

    User.update_all subscribe_to_emails: true
    User.all.each do |user|
      # Putting my advanced degree in copying and pasting from stackoverflow to good use:
      # https://stackoverflow.com/questions/18554306/generating-unique-token-on-the-fly-with-rails#18564387
      user.unsubscribe_token = SecureRandom.urlsafe_base64(16)
      user.save! validate: false
    end
  end
end
