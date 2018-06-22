class MentorMatchProfile < ApplicationRecord
  belongs_to :user

  # t.bigint "user_id"
  # t.string "cv_text"
  # t.string "match_role"
  # t.string "position"
  # t.string "original_cv_drive_id"
  # t.string "cv_gdoc_drive_id"
  # t.boolean "uploaded_cv_exists"
  # t.index "to_tsvector('english'::regconfig, (cv_text)::text)", name: "profile_text_idx", using: :gin

  before_save do
    self.uploaded_cv_exists = false if self.uploaded_cv_exists.nil?
  end

end
