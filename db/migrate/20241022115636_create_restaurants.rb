class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.string :name, null: false
      t.string :brand_name, null: false
      t.string :register_number, null: false
      t.string :comercial_phone, null: false
      t.string :email, null: false

      t.timestamps
    end
  end
end
