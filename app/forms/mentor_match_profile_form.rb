class MentorMatchProfileForm

  include ActiveModel::Model

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

  validates :position, presence: true
  validates :position, length: { maximum: 300 }

  validates :match_role, presence: true
  validates :match_role, inclusion: {in: MentorMatchProfile::Roles }

  validates :seeking_summary, length: { maximum: 50000 }

  validates :career_stage, length: { maximum: 300 }

  validates :user_keywords, length: { maximum: 3000 }

  # Not happy that I have to write this myself, but rails relies on database inspection to autopopulate model attrs... which I don't have here!
  def attributes
    attrs = {}
    AttributesList.each do |attribute_name|
      attrs[attribute_name] = instance_variable_get "@#{attribute_name}"
    end

    attrs
  end

  def assign_attributes (attributes)
    AttributesList.each do |attribute_name|
      instance_variable_set "@#{attribute_name}", attributes[attribute_name]
    end
  end

  def inspect
    ap attributes
  end

end