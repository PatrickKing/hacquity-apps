class CreateConnections < ActiveRecord::Migration[5.2]
  def change
    create_table :connections do |t|
      t.references :first_user
      t.references :second_user

      t.timestamps
    end

  end
end
