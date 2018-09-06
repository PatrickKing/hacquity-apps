class NewMentorMatchProfileAttributes < ActiveRecord::Migration[5.2]
  def change

    add_column :users, :preferred_contact_method, :string
    add_column :users, :phone_number, :string

    add_column :users, :admin_assistant_name, :string
    add_column :users, :admin_assistant_email, :string
    add_column :users, :admin_assistant_phone_number, :string

    add_column :mentor_match_profiles, :available_ongoing, :boolean
    add_column :mentor_match_profiles, :available_email_questions, :boolean
    add_column :mentor_match_profiles, :available_one_off_meetings, :boolean

    add_column :mentor_match_profiles, :mentorship_career, :boolean
    add_column :mentor_match_profiles, :mentorship_life, :boolean
    add_column :mentor_match_profiles, :mentorship_research, :boolean
    add_column :mentor_match_profiles, :mentorship_promotion, :boolean

    add_column :mentor_match_profiles, :career_stage, :string
    add_column :mentor_match_profiles, :career_track, :string

    add_column :mentor_match_profiles, :user_keywords, :string
    add_column :mentor_match_profiles, :user_keywords_gdoc_id, :string

  end
end
