class CreateServicePostings < ActiveRecord::Migration[5.2]
  def change
    create_table :service_postings do |t|
      t.string :posting_type
      t.string :summary
      t.string :description
      t.decimal :full_time_equivalents
      t.references :user, foreign_key: true
      t.boolean :closed

      t.timestamps
    end
  end
end
