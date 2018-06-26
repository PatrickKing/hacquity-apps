class MentorMatchProfileTweaks < ActiveRecord::Migration[5.2]
  def up

    add_column :mentor_match_profiles, :seeking_summary, :string

    # change of plans! going to use google to search the docs
    execute <<-SQL

      DROP INDEX profile_text_idx;

    SQL

  end
end
