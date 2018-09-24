class Admin < ApplicationRecord
  # Other deivse modules available are:
  # :confirmable, :timeoutable and :omniauthable, :registerable,
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  # NB: when creating an admin at console: name, email, password

  def send_devise_notification (notification, *args)
    DeviseMailerJob.new(notification, self, *args).deliver
  end

end
