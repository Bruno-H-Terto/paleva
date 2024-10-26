# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

owner = RestaurantOwner.create!(individual_tax_id: '91348691077', 
                  name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
                  password: 'treina_dev13') 

restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                restaurant_owner: owner)

restaurant.create_address!(street: 'Av. TDD Ruby on Rails', number: 42, district: 'Rubista', city: 'Condado',
                           state: 'MG', zip_code: '36000-000', complement: 'Loja 1')