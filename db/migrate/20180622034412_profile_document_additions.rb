class ProfileDocumentAdditions < ActiveRecord::Migration[5.2]
  def up

    add_column :mentor_match_profiles, :original_cv_drive_id, :string
    add_column :mentor_match_profiles, :cv_gdoc_drive_id, :string
    add_column :mentor_match_profiles, :uploaded_cv_exists, :boolean


    # Postgres full-text search index:
    execute <<-SQL

      CREATE INDEX profile_text_idx ON mentor_match_profiles USING gin(to_tsvector('english', cv_text));

    SQL

  end
end
