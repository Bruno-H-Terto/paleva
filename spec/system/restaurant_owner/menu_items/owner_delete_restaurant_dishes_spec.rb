require 'rails_helper'

describe 'Proprietário deleta Pratos cadastrados' do
  let(:owner) { 
    RestaurantOwner.create!(individual_tax_id: '91348691077', 
    name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
    password: 'treina_dev13') 
  }

  it 'com sucesso' do
    restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                            comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                            restaurant_owner: owner)
    address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                            city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                            user: restaurant, user_type: 'Restaurant')
    restaurant_dish = restaurant.dishes.build
    menu_item = restaurant_dish.build_menu_item(
                              name: 'Carne moída',
                              description: 'Bolinho de carne -  Especial da casa',
                              calories: ''
                            )
    restaurant_dish.save!

    login_as owner, scope: :restaurant_owner
    visit restaurant_path(restaurant)
    click_on 'Carne moída'
    click_on 'Deletar Prato'

    expect(Dish.count).to eq 0
    expect(page).to have_content 'Prato deletado com sucesso'
    expect(page).not_to have_content 'Carne moída'
  end

  it 'e deleta apenas o item selecionado' do
    restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                            comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                            restaurant_owner: owner)
    address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                            city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                            user: restaurant, user_type: 'Restaurant')
    first_restaurant_dish = restaurant.dishes.build
    menu_item = first_restaurant_dish.build_menu_item(
                              name: 'Carne moída',
                              description: 'Bolinho de carne -  Especial da casa',
                              calories: ''
                            )
    first_restaurant_dish.save!

    second_restaurant_dish = restaurant.dishes.build
    menu_item = second_restaurant_dish.build_menu_item(
                              name: 'Pão de queijo',
                              description: '10 unidades',
                              calories: '100'
                            )
    second_restaurant_dish.save!

    login_as owner, scope: :restaurant_owner
    visit restaurant_path(restaurant)
    click_on 'Carne moída'
    click_on 'Deletar Prato'

    expect(Dish.count).to eq 1
    expect(page).to have_content 'Prato deletado com sucesso'
    expect(page).not_to have_content 'Carne moída'
    expect(page).to have_content 'Pão de queijo'
  end

  it 'só pode excluir bebidas do próprio Restaurante' do
    restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
        comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
        restaurant_owner: owner)
    restaurant_dish = restaurant.dishes.build
    menu_item = restaurant_dish.build_menu_item(
                              name: 'Carne moída',
                              description: 'Carne moída importado 1912, 750ml',
                              calories: ''
        )
    restaurant_dish.save!
    other_restaurant_owner = RestaurantOwner.create!(individual_tax_id: '86160052004', 
        name: 'Jhon', surname: 'Doe', email: 'dev2024@ruby.com',
        password: 'treina_dev13')
    other_restaurant = Restaurant.create!(name: 'Toscana Code', brand_name: 'Toscana LTDA', register_number: '71.694.114/0001-27',
        comercial_phone: '(32) 4022-0000', email: 'fitdev@ruby.com', 
        restaurant_owner: other_restaurant_owner)
    other_restaurant_address = Address.create!(street: 'Av 13 de Brumário', number: '99', district: 'Cidade Nova',
        city: 'Pallet City', state: 'SP', zip_code: '72000-000', complement: '',
        user: other_restaurant, user_type: 'Restaurant')

    login_as other_restaurant_owner, scope: :restaurant_owner
    visit restaurant_dish_path(restaurant, restaurant_dish)
    
    expect(page).to have_content 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
    expect(page).not_to have_content 'Deletar Prato'
    expect(page).not_to have_content 'Carne moída'
    expect(Dish.where(restaurant: restaurant).count).to eq 1
  end

end