class BulkUpdateLineItem < ApplicationRecord
  belongs_to :bulk_update_record

  BulkUpdateLineItem::Statuses = [
    'not_processed', # not begun yet

    'error_no_retry', # errored out, and don't allow retries
    'error_retry_permitted', # errored out, but might succeed in the future

    'completed', # finished in such a way that no further work is possible (though some line items may themselves have hit critical errors!)
  ]


  validates :status, inclusion: {in: BulkUpdateLineItem::Statuses }

  def status_colour_class
    case self.status
    when 'not_processed' then ''
    when 'error_no_retry', 'error_retry_permitted' then 'red-font'
    when 'completed' then 'green-font'
    end
  end

  def status_string
    case self.status
    when 'not_processed' then 'Not Processed'
    when 'error_no_retry' then 'Error'
    when 'error_retry_permitted' then 'Error (Can Retry)'
    when 'completed' then 'Completed'
    end
  end


  before_validation do
    self.status = 'not_processed' if self.status.nil?
  end
  
end
