class AddNameSurnameToRestaurantOwner < ActiveRecord::Migration[7.2]
  def change
    add_column :restaurant_owners, :name, :string, null: false
    add_column :restaurant_owners, :surname, :string, null: false
  end
end
