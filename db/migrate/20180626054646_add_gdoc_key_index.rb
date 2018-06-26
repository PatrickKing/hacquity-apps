class AddGdocKeyIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :mentor_match_profiles, :original_cv_drive_id
  end
end
