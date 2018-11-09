class AddUserAccessControlAttributes < ActiveRecord::Migration[5.2]
  def change

    add_column :users, :admin_approved, :datetime
    add_column :users, :admin_disabled, :datetime
  end
end
