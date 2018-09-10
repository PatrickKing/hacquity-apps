class MentorMatchProfile < ApplicationRecord
  belongs_to :user

  MentorMatchProfile::Roles = [
    'Not Seeking',
    'Seeking to be a Mentor',
    'Seeking to be a Mentee',
    'Seeking Both'
  ]

  validates :position, presence: true
  validates :position, length: { maximum: 300 }

  validates :match_role, presence: true
  validates :match_role, inclusion: {in: MentorMatchProfile::Roles }

  validates :seeking_summary, length: { maximum: 50000 }


  validates :career_stage, length: { maximum: 300 }

  validates :user_keywords, length: { maximum: 3000 }



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
