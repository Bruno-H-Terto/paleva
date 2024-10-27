class CreateBusinessHours < ActiveRecord::Migration[7.2]
  def change
    create_table :business_hours do |t|
      t.integer :day_of_week, null: false
      t.integer :status, default: 0
      t.time :open_time
      t.time :close_time
      t.references :restaurant, foreign_key: true

      t.timestamps
    end
  end
end
