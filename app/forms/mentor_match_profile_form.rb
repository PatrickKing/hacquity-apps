class MentorMatchProfileForm

  include ActiveModel::Model
  include FormMethods

  AttributesList = [
    'match_role',
    'position',
    'seeking_summary',
    'available_ongoing',
    'available_email_questions',
    'available_one_off_meetings',
    'career_stage',
    'user_keywords',
    'mentorship_opportunities',
    'mentorship_promotion_tenure',
    'mentorship_career_life_balance',
    'mentorship_performance',
    'mentorship_networking',
    'career_track_research',
    'career_track_education',
    'career_track_policy',
    'career_track_leadership_admin',
    'career_track_clinical',
  ]

  attr_accessor *AttributesList

  def attributes_list
    AttributesList
  end

  validates :position, presence: true
  validates :position, length: { maximum: 300 }

  validates :match_role, presence: true
  validates :match_role, inclusion: {in: MentorMatchProfile::Roles }

  validates :seeking_summary, length: { maximum: 50000 }

  validates :career_stage, length: { maximum: 300 }

  validates :user_keywords, length: { maximum: 3000 }


end