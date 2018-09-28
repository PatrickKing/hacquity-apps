class BulkUpdateRecord < ApplicationRecord
  belongs_to :admin
  has_many :bulk_update_line_items

  BulkUpdateRecord::Statuses = [
    'created', # not begun yet

    'in_progress', # set once we begin to process records

    'error_no_retry', # errored out, and don't allow retries. Specifically, this status means that the job as a whole encountered a terminal error. If one of the line items encounters a terminal error, but the job completes, the job as a whole will be considered complete.

    'error_retry_permitted', # errored out, but might succeed in the future. This status is to be assigned if any of the line items hits the same status.

    'will_retry', # same meaning as error_retry_permitted, except to help us signal to the user that a new job has kicked off

    'completed', # finished in such a way that no further work is possible (though some line items may themselves have hit critical errors!)
  ]


  validates :status, inclusion: {in: BulkUpdateRecord::Statuses }

  def status_colour_class
    case self.status
    when 'created', 'in_progress' then ''
    when 'error_no_retry', 'error_retry_permitted' then 'red-font'
    when 'completed' then 'green-font'
    end
  end

  def can_retry?
    self.status == 'error_retry_permitted'
  end

  def can_refresh?
    self.status == 'created' or self.status == 'in_progress' or self.status == 'will_retry'
  end

  def status_string
    case self.status
    when 'created' then 'Created'
    when 'in_progress' then 'In Progress'
    when 'error_no_retry' then 'Error'
    when 'error_retry_permitted' then 'Error (Can Retry)'
    when 'will_retry' then 'Retrying...'
    when 'completed' then 'Completed'
    end
  end

  before_validation do
    self.status = 'created' if self.status.nil?
  end

end
