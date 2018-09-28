class BulkUpdateLineItem < ApplicationRecord
  belongs_to :bulk_update_record

  BulkUpdateLineItem::Statuses = [
    'not_processed', # not begun yet

    'error_no_retry', # errored out, and don't allow retries
    'error_retry_permitted', # errored out, but might succeed in the future

    'completed', # finished in such a way that no further work is possible (though some line items may themselves have hit critical errors!)
  ]


  validates :status, inclusion: {in: BulkUpdateLineItem::Statuses }

  before_validation do
    self.status = 'not_processed' if self.status.nil?
  end
  
end
