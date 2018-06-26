class ProfileWebViewLink < ActiveRecord::Migration[5.2]
  def change
    add_column :mentor_match_profiles, :web_view_link, :string
  end
end
