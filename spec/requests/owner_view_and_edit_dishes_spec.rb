require 'rails_helper'

describe 'Proprietário edita pratos de seu Restaurante' do
  context 'GET /restaurants/:restaurant_id/dishes/:id' do
    it 'e não está autenticado' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      restaurant_dish = restaurant.dishes.build
      menu_item = restaurant_dish.build_menu_item(
              name: 'Carne moída',
              description: 'Bolinho de carne -  Especial da casa',
              calories: ''
            )
      restaurant_dish.save!

      get restaurant_dish_path(restaurant, restaurant_dish)

      expect(response).to redirect_to new_restaurant_owner_session_path
    end

    it 'e não é o dono' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      restaurant_dish = restaurant.dishes.build
      menu_item = restaurant_dish.build_menu_item(
              name: 'Carne moída',
              description: 'Bolinho de carne -  Especial da casa',
              calories: ''
            )
      restaurant_dish.save!
      other_restaurant_owner = RestaurantOwner.create!(individual_tax_id: '86160052004', 
              name: 'Jhon', surname: 'Doe', email: 'dev2024@ruby.com',
              password: 'treina_dev13')
      other_restaurant = Restaurant.create!(name: 'Toscana Code', brand_name: 'Toscana LTDA', register_number: '71.694.114/0001-27',
              comercial_phone: '(32) 4022-0000', email: 'fitdev@ruby.com', 
              restaurant_owner: other_restaurant_owner)    

      login_as other_restaurant_owner, scopo: :restaurant_owner
      get restaurant_dish_path(restaurant, restaurant_dish)

      expect(response).to redirect_to restaurant_path(other_restaurant)
    end
  end

  context 'PATCH  /restaurants/:restaurant_id/dishes/:id' do
    it 'e não está autenticado' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      restaurant_dish = restaurant.dishes.build
      menu_item = restaurant_dish.build_menu_item(
              name: 'Carne moída',
              description: 'Bolinho de carne -  Especial da casa',
              calories: ''
            )
      restaurant_dish.save!

      patch restaurant_dish_path(restaurant, restaurant_dish), params: { name: 'New dish'}

      expect(response).to redirect_to new_restaurant_owner_session_path
    end

    it 'e não é o dono' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      restaurant_dish = restaurant.dishes.build
      menu_item = restaurant_dish.build_menu_item(
              name: 'Carne moída',
              description: 'Bolinho de carne -  Especial da casa',
              calories: ''
            )
      restaurant_dish.save!
      other_restaurant_owner = RestaurantOwner.create!(individual_tax_id: '86160052004', 
              name: 'Jhon', surname: 'Doe', email: 'dev2024@ruby.com',
              password: 'treina_dev13')
      other_restaurant = Restaurant.create!(name: 'Toscana Code', brand_name: 'Toscana LTDA', register_number: '71.694.114/0001-27',
              comercial_phone: '(32) 4022-0000', email: 'fitdev@ruby.com', 
              restaurant_owner: other_restaurant_owner)    

      login_as other_restaurant_owner, scopo: :restaurant_owner
      patch restaurant_dish_path(restaurant, restaurant_dish), params: { name: 'New dish'}

      expect(response).to redirect_to restaurant_path(other_restaurant)
      expect(restaurant_dish.menu_item.name).not_to eq 'New dish'
      expect(restaurant_dish.menu_item.name).to eq 'Carne moída'
    end
  end
end