class CreateServicePostings < ActiveRecord::Migration[5.2]
  def change
    create_table :service_postings do |t|
      t.string :postingType
      t.string :summary
      t.string :description
      t.decimal :fullTimeEquivalents
      t.references :user, foreign_key: true
      t.boolean :closed

      t.timestamps
    end
  end
end
