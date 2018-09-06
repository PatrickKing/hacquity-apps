class MentorMatchProfile < ApplicationRecord
  belongs_to :user

  MentorMatchProfile::Roles = [
    'Not Seeking',
    'Seeking to be a Mentor',
    'Seeking to be a Mentee',
    'Seeking Both'
  ]

  MentorMatchProfile::CareerTracks = [
    '',
    'academic',
    'non-academic'
  ]



  validates :position, presence: true
  validates :position, length: { maximum: 300 }

  validates :match_role, presence: true
  validates :match_role, inclusion: {in: MentorMatchProfile::Roles }

  validates :seeking_summary, length: { maximum: 50000 }

  validates :career_track, inclusion: {in: MentorMatchProfile::CareerTracks }

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
    self.mentorship_career || self.mentorship_life || self.mentorship_research || self.mentorship_promotion
  end

  before_validation do
    self.uploaded_cv_exists = false if self.uploaded_cv_exists.nil?
    self.match_role = 'Not Seeking' if self.match_role.blank?

    self.career_track = '' if self.career_track.nil?

    self.available_ongoing = false if self.available_ongoing.nil?
    self.available_email_questions = false if self.available_email_questions.nil?
    self.available_one_off_meetings = false if self.available_one_off_meetings.nil?
    self.mentorship_career = false if self.mentorship_career.nil?
    self.mentorship_life = false if self.mentorship_life.nil?
    self.mentorship_research = false if self.mentorship_research.nil?
    self.mentorship_promotion = false if self.mentorship_promotion.nil?
  end


end
