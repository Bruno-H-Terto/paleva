require 'rails_helper'

describe 'Proprietário edita bebida de seu Restaurante' do
  context 'GET /restaurants/:restaurant_id/beverages/:id' do
    it 'e não está autenticado' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      restaurant_beverage = restaurant.beverages.build
      menu_item = restaurant_beverage.build_menu_item(
              name: 'Coca-Cola',
              description: 'Tradicional 2L',
              calories: ''
            )
      restaurant_beverage.save!

      get restaurant_beverage_path(restaurant, restaurant_beverage)

      expect(response).to redirect_to new_restaurant_owner_session_path
    end

    it 'e não é o dono' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      restaurant_beverage = restaurant.beverages.build
      menu_item = restaurant_beverage.build_menu_item(
              name: 'Coca-Cola',
              description: 'Tradicional 2L',
              calories: ''
            )
      restaurant_beverage.save!
      other_restaurant_owner = RestaurantOwner.create!(individual_tax_id: '86160052004', 
              name: 'Jhon', surname: 'Doe', email: 'dev2024@ruby.com',
              password: 'treina_dev13')
      other_restaurant = Restaurant.create!(name: 'Toscana Code', brand_name: 'Toscana LTDA', register_number: '71.694.114/0001-27',
              comercial_phone: '(32) 4022-0000', email: 'fitdev@ruby.com', 
              restaurant_owner: other_restaurant_owner)    

      login_as other_restaurant_owner, scopo: :restaurant_owner
      get restaurant_beverage_path(restaurant, restaurant_beverage)

      expect(response).to redirect_to restaurant_path(other_restaurant)
    end
  end

  context 'PATCH  /restaurants/:restaurant_id/beverages/:id' do
    it 'e não está autenticado' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      restaurant_beverage = restaurant.beverages.build
      menu_item = restaurant_beverage.build_menu_item(
              name: 'Coca-Cola',
              description: 'Tradicional 2L',
              calories: ''
            )
      restaurant_beverage.save!

      patch restaurant_beverage_path(restaurant, restaurant_beverage), params: { name: 'New beverage'}

      expect(response).to redirect_to new_restaurant_owner_session_path
    end

    it 'e não é o dono' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      restaurant_beverage = restaurant.beverages.build
      menu_item = restaurant_beverage.build_menu_item(
              name: 'Coca-Cola',
              description: 'Tradicional 2L',
              calories: ''
            )
      restaurant_beverage.save!
      other_restaurant_owner = RestaurantOwner.create!(individual_tax_id: '86160052004', 
              name: 'Jhon', surname: 'Doe', email: 'dev2024@ruby.com',
              password: 'treina_dev13')
      other_restaurant = Restaurant.create!(name: 'Toscana Code', brand_name: 'Toscana LTDA', register_number: '71.694.114/0001-27',
              comercial_phone: '(32) 4022-0000', email: 'fitdev@ruby.com', 
              restaurant_owner: other_restaurant_owner)    

      login_as other_restaurant_owner, scopo: :restaurant_owner
      patch restaurant_beverage_path(restaurant, restaurant_beverage), params: { name: 'New beverage'}

      expect(response).to redirect_to restaurant_path(other_restaurant)
      expect(restaurant_beverage.menu_item.name).not_to eq 'New beverage'
      expect(restaurant_beverage.menu_item.name).to eq 'Coca-Cola'
    end
  end

  context 'DELETE /restaurants/:restaurant_id/beverages/:id' do
    it 'e não está autenticado' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      restaurant_beverage = restaurant.beverages.build
      menu_item = restaurant_beverage.build_menu_item(
              name: 'Coca-Cola',
              description: 'Tradicional 2L',
              calories: ''
            )
      restaurant_beverage.save!

      delete restaurant_beverage_path(restaurant, restaurant_beverage)

      expect(response).to redirect_to new_restaurant_owner_session_path
      expect(Beverage.count).to eq 1
      expect(MenuItem.count).to eq 1
    end

    it 'e não é o dono' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      restaurant_beverage = restaurant.beverages.build
      menu_item = restaurant_beverage.build_menu_item(
              name: 'Coca-Cola',
              description: 'Tradicional 2L',
              calories: ''
            )
      restaurant_beverage.save!
      other_restaurant_owner = RestaurantOwner.create!(individual_tax_id: '86160052004', 
              name: 'Jhon', surname: 'Doe', email: 'dev2024@ruby.com',
              password: 'treina_dev13')
      other_restaurant = Restaurant.create!(name: 'Toscana Code', brand_name: 'Toscana LTDA', register_number: '71.694.114/0001-27',
              comercial_phone: '(32) 4022-0000', email: 'fitdev@ruby.com', 
              restaurant_owner: other_restaurant_owner)    

      login_as other_restaurant_owner, scopo: :restaurant_owner
      delete restaurant_beverage_path(restaurant, restaurant_beverage)

      expect(response).to redirect_to restaurant_path(other_restaurant)
      expect(Beverage.count).to eq 1
      expect(MenuItem.count).to eq 1
    end
  end
end