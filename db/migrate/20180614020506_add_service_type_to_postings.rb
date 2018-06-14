class AddServiceTypeToPostings < ActiveRecord::Migration[5.2]
  def change
    add_column :service_postings, :service_type, :string
  end
end
