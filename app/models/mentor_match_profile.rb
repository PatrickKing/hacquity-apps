class MentorMatchProfile < ApplicationRecord
  belongs_to :user

  # These scopes are designed to take a mentor_match_filter_form object as argument

  scope :with_availabilities, -> (filters) {
    filter_pieces = []

    if filters.available_ongoing == '1'
      filter_pieces.push 'available_ongoing = true'
    end
    if filters.available_email_questions == '1'
      filter_pieces.push 'available_email_questions = true'
    end
    if filters.available_one_off_meetings == '1'
      filter_pieces.push 'available_one_off_meetings = true'
    end

    if filter_pieces.empty?
      all
    else
      where filter_pieces.join(' OR ')
    end
  }

  scope :with_areas, -> (filters) {
    filter_pieces = []

    if filters.mentorship_opportunities == '1'
      filter_pieces.push 'mentorship_opportunities = true'
    end
    if filters.mentorship_promotion_tenure == '1'
      filter_pieces.push 'mentorship_promotion_tenure = true'
    end
    if filters.mentorship_career_life_balance == '1'
      filter_pieces.push 'mentorship_career_life_balance = true'
    end
    if filters.mentorship_performance == '1'
      filter_pieces.push 'mentorship_performance = true'
    end
    if filters.mentorship_networking == '1'
      filter_pieces.push 'mentorship_networking = true'
    end

    if filter_pieces.empty?
      all
    else
      where filter_pieces.join(' OR ')
    end
  }

  scope :with_tracks, -> (filters) {
    filter_pieces = []

    if filters.career_track_research == '1'
      filter_pieces.push 'career_track_research = true'
    end
    if filters.career_track_education == '1'
      filter_pieces.push 'career_track_education = true'
    end
    if filters.career_track_policy == '1'
      filter_pieces.push 'career_track_policy = true'
    end
    if filters.career_track_leadership_admin == '1'
      filter_pieces.push 'career_track_leadership_admin = true'
    end
    if filters.career_track_clinical == '1'
      filter_pieces.push 'career_track_clinical = true'
    end

    if filter_pieces.empty?
      all
    else
      where filter_pieces.join(' OR ')
    end
  }

  MentorMatchProfile::Roles = [
    'Not Seeking',
    'Seeking to be a Mentor',
    'Seeking to be a Mentee',
    'Seeking Both'
  ]

  # NB: see mentor_match_profile_form for user facing validations.

  def role_display_text
    case self.match_role
    when 'Not Seeking'
      'Not currently seeking mentorship roles'
    when 'Seeking to be a Mentor'
      'Seeking to be a mentor'
    when 'Seeking to be a Mentee'
      'Seeking to be a mentee'
    when 'Seeking Both'
      'Seeking both to be a mentor and to be a mentee'
    end
  end

  def seeking?
    case self.match_role
    when 'Not Seeking'
      'false'
    when 'Seeking to be a Mentor', 'Seeking to be a Mentee', 'Seeking Both'
      'true'
    end
    
  end

  def any_availability?
    self.available_ongoing || self.available_email_questions || self.available_one_off_meetings
  end

  def any_mentorship_areas?
    self.mentorship_opportunities || self.mentorship_promotion_tenure || self.mentorship_career_life_balance || self.mentorship_performance || self.mentorship_networking
  end


  def any_career_tracks?
    self.career_track_research || self.career_track_education || self.career_track_policy || self.career_track_leadership_admin || self.career_track_clinical
  end

  def search_document
    [position, seeking_summary, career_stage, user_keywords].join ' '
  end

  before_validation do
    self.uploaded_cv_exists = false if self.uploaded_cv_exists.nil?
    self.match_role = 'Not Seeking' if self.match_role.blank?


    self.available_ongoing = false if self.available_ongoing.nil?
    self.available_email_questions = false if self.available_email_questions.nil?
    self.available_one_off_meetings = false if self.available_one_off_meetings.nil?

    self.mentorship_opportunities = false if self.mentorship_opportunities.nil?
    self.mentorship_promotion_tenure = false if self.mentorship_promotion_tenure.nil?
    self.mentorship_career_life_balance = false if self.mentorship_career_life_balance.nil?
    self.mentorship_performance = false if self.mentorship_performance.nil?
    self.mentorship_networking = false if self.mentorship_networking.nil?
    self.career_track_research = false if self.career_track_research.nil?
    self.career_track_education = false if self.career_track_education.nil?
    self.career_track_policy = false if self.career_track_policy.nil?
    self.career_track_leadership_admin = false if self.career_track_leadership_admin.nil?
    self.career_track_clinical = false if self.career_track_clinical.nil?

  end


end
