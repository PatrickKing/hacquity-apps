class MentorMatchFilterForm

  include ActiveModel::Model
  include FormMethods

  AttributesList = [
    'query',

    'available_ongoing',
    'available_email_questions',
    'available_one_off_meetings',

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

end