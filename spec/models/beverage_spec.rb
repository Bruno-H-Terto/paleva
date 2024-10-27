require 'rails_helper'

RSpec.describe Beverage, type: :model do
  context '#valid?' do
    it { should have_one(:menu_item)}
    it { should belong_to(:restaurant)}
    it { should validate_presence_of(:menu_item) }
    it { should accept_nested_attributes_for(:menu_item) }

    it 'deve ter um menu item' do
      beverage = Beverage.new
      beverage.valid?
      expect(beverage).not_to be_valid
      expect(beverage.errors[:menu_item]).to include('não pode ficar em branco')
    end

    it 'deleta a listagem do menu caso a Bebida seja deletada' do
      owner =  RestaurantOwner.create!(individual_tax_id: '91348691077', 
                    name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
                    password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                    comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                    restaurant_owner: owner)
      restaurant_drink = restaurant.beverages.build
      menu_item = restaurant_drink.build_menu_item(
                            name: 'Vinho tinto',
                            description: 'Vinho tinto importa 1912, 750ml',
                            calories: ''
                          )
      restaurant_drink.save!

      restaurant_drink.destroy!

      expect(MenuItem.count).to eq 0
      expect(Dish.count).to eq 0
    end
  end
end
