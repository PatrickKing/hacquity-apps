class ProfileMetadata < ActiveRecord::Migration[5.2]
  def change

    remove_column :mentor_match_profiles, :web_view_link

    add_column :mentor_match_profiles, :original_cv_mime_type, :string
    add_column :mentor_match_profiles, :original_cv_file_name, :string

  end
end
