class AdditionalDeviseUserFeatures < ActiveRecord::Migration[5.2]
  def up

    change_table :users do |t|

      ## Confirmable
      t.string   :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
      t.string   :unconfirmed_email # Only if using reconfirmable
      # not currently using reconfirmable, adding the field in case I decide to

      ## Lockable
      t.integer  :failed_attempts, default: 0, null: false # Only if lock strategy is :failed_attempts
      t.string   :unlock_token # Only if unlock strategy is :email or :both
      t.datetime :locked_at
    end

    add_index :users, :confirmation_token,   unique: true
    add_index :users, :unlock_token,         unique: true
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
