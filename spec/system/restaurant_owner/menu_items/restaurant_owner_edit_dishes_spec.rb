require 'rails_helper'

describe 'Proprietário edita Pratos cadastrados' do
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
                              name: 'Carne moida simples',
                              description: 'Um bolinho de carne moída simples, bem temperado e carnudo. A farinha de trigo é usada apenas para dar consistência à massa.',
                              calories: ''
                            )
    restaurant_dish.save!

    login_as owner, scope: :restaurant_owner
    visit restaurant_path(restaurant)
    click_on 'Carne moida simples'
    click_on 'Editar Prato'
    fill_in 'Nome', with: 'Bolinho de carne moída Especial da casa'
    fill_in 'Descrição', with: 'Um bolinho de carne moída tradicional do estabelecimento.'
    fill_in 'Calorias', with: '40'
    attach_file 'Foto demonstrativa', Rails.root.join('spec', 'support', 'bolinho_de_carne_moida.jpg')
    click_on 'Atualizar Prato'

    expect(Dish.count).to eq 1
    expect(page).to have_content 'Prato atualizado com sucesso'
    expect(page).to have_content 'Prato: Bolinho de carne moída Especial da casa'
    expect(page).to have_content 'Um bolinho de carne moída tradicional do estabelecimento.'
    expect(page).to have_content 'Calorias: 40'
    expect(page).to have_css('img[src*="bolinho_de_carne_moida.jpg"]')
  end

  it 'e falha ao não preencher campos obrigatórios' do
    restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                            comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                            restaurant_owner: owner)
    address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                            city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                            user: restaurant, user_type: 'Restaurant')
    restaurant_dish = restaurant.dishes.build
    menu_item = restaurant_dish.build_menu_item(
                              name: 'Carne moida simples',
                              description: 'Um bolinho de carne moída simples, bem temperado e carnudo. A farinha de trigo é usada apenas para dar consistência à massa.',
                              calories: ''
                            )
    restaurant_dish.save!

    login_as owner, scope: :restaurant_owner
    visit restaurant_path(restaurant)
    click_on 'Carne moida simples'
    click_on 'Editar Prato'
    fill_in 'Nome', with: ''
    fill_in 'Descrição', with: ''
    fill_in 'Calorias', with: '40'
    click_on 'Atualizar Prato'

    expect(page).to have_content 'Não foi possível atualizar o Prato'
    expect(page).to have_content 'Nome não pode ficar em branco'
    expect(page).to have_content 'Description não pode ficar em branco'
  end

  it 'e só pode editar Pratos do próprio restaurante' do
    restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
        comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
        restaurant_owner: owner)
    restaurant_dish = restaurant.dishes.build
    menu_item = restaurant_dish.build_menu_item(
          name: 'Carne moida simples',
          description: 'Um bolinho de carne moída simples, bem temperado e carnudo. A farinha de trigo é usada apenas para dar consistência à massa.',
          calories: ''
        )
    restaurant_dish.save!
    other_restaurant_owner = RestaurantOwner.create!(individual_tax_id: '86160052004', 
        name: 'Jhon', surname: 'Doe', email: 'dev2024@ruby.com',
        password: 'treina_dev13')
    other_restaurant = Restaurant.new(name: 'Toscana Code', brand_name: 'Toscana LTDA', register_number: '71.694.114/0001-27',
        comercial_phone: '(32) 4022-0000', email: 'fitdev@ruby.com', 
        restaurant_owner: other_restaurant_owner)
    other_restaurant_address = Address.create!(street: 'Av 13 de Brumário', number: '99', district: 'Cidade Nova',
        city: 'Pallet City', state: 'SP', zip_code: '72000-000', complement: '',
        user: other_restaurant, user_type: 'Restaurant')


    login_as other_restaurant_owner, scope: :restaurant_owner
    visit edit_restaurant_dish_path(restaurant, restaurant_dish)

    expect(page).to have_content 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
    expect(page).not_to have_content 'Carne moida simples'
    expect(page).not_to have_content 'Rubistas'
    expect(page).to have_content 'Toscana Code'
    expect(page).to have_content 'Av 13 de Brumário'
  end
end