
class DeviseMailerJob

  def initialize (notification, record, *args)
    @notification = notification
    @record = record
    @args = args
  end

  def deliver
    @record.deliver_now @notification, @args
  end

  handle_asynchronously :deliver

end