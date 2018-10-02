class CreateBulkUpdateLineItems < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_update_line_items do |t|
      t.references :bulk_update_record, foreign_key: true
      t.string :filename
      t.string :email
      t.string :status
      t.string :error_message

      t.timestamps
    end
  end
end
