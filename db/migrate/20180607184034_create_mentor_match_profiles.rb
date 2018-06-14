class CreateMentorMatchProfiles < ActiveRecord::Migration[5.2]
  def change
    create_table :mentor_match_profiles do |t|
      t.references :user, foreign_key: true
      t.string :cv_text
      t.string :match_role
      t.string :position

      t.timestamps
    end
  end
end
