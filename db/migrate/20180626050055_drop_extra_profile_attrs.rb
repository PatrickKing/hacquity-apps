class DropExtraProfileAttrs < ActiveRecord::Migration[5.2]
  def change
    remove_column :mentor_match_profiles, :cv_text
    remove_column :mentor_match_profiles, :cv_gdoc_drive_id
  end
end
