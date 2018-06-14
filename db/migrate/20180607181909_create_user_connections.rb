class CreateUserConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :user_connections do |t|
      t.references :initiator, foreign_key: { to_table: :users }, index: true
      t.references :receiver, foreign_key: { to_table: :users }, index: true
      t.string :connection_type
      t.references :initiator_posting, foreign_key: { to_table: :service_postings }, index: true
      t.references :receiver_posting, foreign_key: { to_table: :service_postings }, index: true
      t.boolean :accepted
      t.boolean :declined

      t.timestamps
    end
  end
end
