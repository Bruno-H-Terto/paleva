class AddReferencesOwnerToRestaurant < ActiveRecord::Migration[7.2]
  def change
    add_reference :restaurants, :restaurant_owner, null: false, foreign_key: true
  end
end
