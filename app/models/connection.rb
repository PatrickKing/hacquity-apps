class Connection < ApplicationRecord

  # TODO: add foreign key constraints for these two in a migration ...
  # TODO: a combined first_user, second_user index might be a good idea

  belongs_to :first_user, class_name: 'User'
  belongs_to :second_user, class_name: 'User'


  # TODO: do I need these really?
  validates :first_user, presence: true
  validates :second_user, presence: true


  def self.connect_users(first_user, second_user)

    if connection_exists? first_user, second_user
      # TODO If the connection exists, we silently return... should we be erroring out here?
      STEDERR.puts "Connection for users #{first_user.email} and #{second_user.email} already exists."
      return
    end

    # We represent our social network as a directed graph, and create both edges for each connection.
    # The case where one edge exists but the other does not should never occur, but if it does we will create just that edge.
    Connection.where(first_user: first_user, second_user: second_user).first_or_create
    Connection.where(first_user: second_user, second_user: first_user).first_or_create

  end

  def self.connection_exists?(first_user, second_user)
    # The case where one edge exists but the other does not should never occur, but if it does we consider the users not connected.
    Connection.find_by(first_user: first_user, second_user: second_user) and
    Connection.find_by(first_user: second_user, second_user: first_user)
  end

end
