class BulkUpdateRecordErrorMessage < ActiveRecord::Migration[5.2]
  def change
    add_column :bulk_update_records, :error_message, :string
  end
end
