class MentorMatchProfileRevisions < ActiveRecord::Migration[5.2]
  def change

    remove_column :mentor_match_profiles, :mentorship_career, :boolean
    remove_column :mentor_match_profiles, :mentorship_life, :boolean
    remove_column :mentor_match_profiles, :mentorship_research, :boolean
    remove_column :mentor_match_profiles, :mentorship_promotion, :boolean

    remove_column :mentor_match_profiles, :career_track, :string

    add_column :mentor_match_profiles, :mentorship_opportunities, :boolean
    add_column :mentor_match_profiles, :mentorship_promotion_tenure, :boolean
    add_column :mentor_match_profiles, :mentorship_career_life_balance, :boolean
    add_column :mentor_match_profiles, :mentorship_performance, :boolean
    add_column :mentor_match_profiles, :mentorship_networking, :boolean

    add_column :mentor_match_profiles, :career_track_research, :boolean
    add_column :mentor_match_profiles, :career_track_education, :boolean
    add_column :mentor_match_profiles, :career_track_policy, :boolean
    add_column :mentor_match_profiles, :career_track_leadership_admin, :boolean
    add_column :mentor_match_profiles, :career_track_clinical, :boolean

  end
end
