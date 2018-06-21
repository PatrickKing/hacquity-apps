class CreateConnectionRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :connection_requests do |t|
      t.references :initiator, foreign_key: { to_table: :users }, index: true
      t.references :receiver, foreign_key: { to_table: :users }, index: true
      t.references :initiator_service_posting, foreign_key: { to_table: :service_postings }, index: true
      t.references :receiver_service_posting, foreign_key: { to_table: :service_postings }, index: true
      t.string :receiver_status
      t.string :initiator_status
      t.string :connection_type

      t.timestamps
    end
  end
end
