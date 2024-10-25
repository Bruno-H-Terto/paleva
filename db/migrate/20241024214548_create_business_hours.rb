class CreateBusinessHours < ActiveRecord::Migration[7.2]
  def change
    create_table :business_hours do |t|
      t.integer :day_of_week, null: false
      t.integer :status, default: 0
      t.string :open_time
      t.string :close_time
      t.references :restaurant, foreign_key: true

      t.timestamps
    end
  end
end
