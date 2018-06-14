class UserAttrs < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :second_shift_enabled, :boolean
    add_column :users, :mentor_match_enabled, :boolean
  end
end
