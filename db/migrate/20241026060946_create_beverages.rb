class CreateBeverages < ActiveRecord::Migration[7.2]
  def change
    create_table :beverages do |t|
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
