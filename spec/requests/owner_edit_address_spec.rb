require 'rails_helper'

describe 'Proprietário edita o endereço de seu Restaurante' do
  context 'PATCH  /restaurants/:restaurant_id/address/:id' do
    it 'e não está autenticado' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      address = Address.create!(street: 'Av. TDD Ruby on Rails', number: 42, district: 'Rubista', city: 'Condado',
              state: 'MG', zip_code: '36000-000', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      patch restaurant_address_path(restaurant, address), params: { address: { street: 'New street'} }

      expect(response).to redirect_to new_restaurant_owner_session_path
    end

    it 'e não é o dono' do
      owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
              name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
              password: 'treina_dev13')
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
              restaurant_owner: owner)
      address = Address.create!(street: 'Av. TDD Ruby on Rails', number: 42, district: 'Rubista', city: 'Condado',
              state: 'MG', zip_code: '36000-000', complement: 'Loja 1', user: restaurant, user_type: Restaurant)
      other_restaurant_owner = RestaurantOwner.create!(individual_tax_id: '86160052004', 
              name: 'Jhon', surname: 'Doe', email: 'dev2024@ruby.com',
              password: 'treina_dev13')
      other_restaurant = Restaurant.create!(name: 'Toscana Code', brand_name: 'Toscana LTDA', register_number: '71.694.114/0001-27',
              comercial_phone: '(32) 4022-0000', email: 'fitdev@ruby.com', 
              restaurant_owner: other_restaurant_owner)    

      login_as other_restaurant_owner, scopo: :restaurant_owner
      patch restaurant_address_path(restaurant, address), params: { address: { street: 'New street'} }

      expect(response).to redirect_to restaurant_path(other_restaurant)
      expect(address.street).not_to eq 'New street'
      expect(address.street).not_to eq 'AV. TDD Ruby on Rails'
    end
  end
end