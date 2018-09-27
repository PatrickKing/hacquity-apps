class CreateBulkUpdateRecords < ActiveRecord::Migration[5.2]
  def change
    create_table :bulk_update_records do |t|
      t.string :status
      t.string :s3_zip_id
      t.references :admin, foreign_key: true

      t.timestamps
    end
  end
end
