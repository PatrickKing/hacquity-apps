class UserConnection < ApplicationRecord
  belongs_to :initiator, class_name: "User"
  belongs_to :receiver, class_name: "User"
  belongs_to :initiator_posting, class_name: "ServicePosting"
  belongs_to :receiver_posting, class_name: "ServicePosting"
end
