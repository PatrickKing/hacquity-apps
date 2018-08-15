class Connection < ApplicationRecord

  # TODO: add foreign key constraints for these two in a migration ... 

  belongs_to :first_user, class_name: 'User'
  belongs_to :second_user, class_name: 'User'


  # TODO: do I need these really?
  validates :first_user, presence: true
  validates :second_user, presence: true


  def self.connect_users(first_user, second_user)

    if not Connection.find_by(first_user: first_user, second_user: second_user).nil? or not Connection.find_by(first_user: second_user, second_user: first_user).nil?
      # TODO If the connection exists, we silently return... should we be erroring out here?
      STEDERR.puts "Connection for users #{first_user.email} and #{second_user.email} already exists."
      return
    end

    # We represent our social network as a directed graph, and create both edges for each connection.
    Connection.create first_user: first_user, second_user: second_user
    Connection.create first_user: second_user, second_user: first_user

  end

end
