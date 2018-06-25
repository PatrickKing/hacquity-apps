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

  before_save do
    self.uploaded_cv_exists = false if self.uploaded_cv_exists.nil?
    self.match_role = 'Not Seeking' if self.match_role.blank?
  end


end
