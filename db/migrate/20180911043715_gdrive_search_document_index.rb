class GdriveSearchDocumentIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :mentor_match_profiles, :user_keywords_gdoc_id
  end
end
