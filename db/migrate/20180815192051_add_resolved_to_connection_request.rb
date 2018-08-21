class AddResolvedToConnectionRequest < ActiveRecord::Migration[5.2]
  def change

    add_column :connection_requests, :resolved, :boolean
  end
end
