class DropUserConnections < ActiveRecord::Migration[5.2]
  drop_table :user_connections
end
