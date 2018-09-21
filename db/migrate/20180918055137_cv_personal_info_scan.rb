class CvPersonalInfoScan < ActiveRecord::Migration[5.2]
  def change
    add_column :mentor_match_profiles, :personal_information, :string
  end
end
