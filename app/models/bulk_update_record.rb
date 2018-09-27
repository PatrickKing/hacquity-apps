class BulkUpdateRecord < ApplicationRecord
  belongs_to :admin
  has_many :bulk_update_line_items

  BulkUpdateRecord::Statuses = [
    'created', # not begun yet

    'in progress', # set once we begin to process records

    'error_no_retry', # errored out, and don't allow retries
    'error_retry_permitted', # errored out, but might succeed in the future

    'completed', # finished in such a way that no further work is possible (though some line items may themselves have hit critical errors!)
  ]


  validates :status, inclusion: {in: BulkUpdateRecord::Statuses }


  before_validation do
    self.status = 'created' if self.status.nil?
  end

end
