require 'rails_helper'

describe 'Proprietário busca por itens cadastrados' do
  let!(:owner) { 
    RestaurantOwner.create!(individual_tax_id: '91348691077', 
    name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
    password: 'treina_dev13') 
  }

  let!(:restaurant) {
    Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
    comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
    restaurant_owner: owner)
  }
  let!(:address) {
    Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
    city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
    user: restaurant, user_type: 'Restaurant')
  }

  def new_item_in_menu(type, name, description, calories)
    if type == 'dish'
      dish = restaurant.dishes.build
      dish.build_menu_item(
          name: name,
          description: description,
          calories: calories
        ).save!
    else
      drink = restaurant.beverages.build
      drink.build_menu_item(
          name: 'Vinho tinto',
          description: 'Vinho tinto importa 1912, 750ml',
          calories: calories
        ).save!
    end
  end

  it 'com multiplos resultados' do
    new_item_in_menu('dish', 'Carne moída', 'Especial da casa', 30)
    new_item_in_menu('dish', 'Carne mal passada', 'Carne bovina', 100)
    new_item_in_menu('dish', 'Churrasco', 'Variadas opções de carne', 150)
    new_item_in_menu('drink', 'Coca-Cola', 'Tradicional 2l', 150)

    login_as owner, scope: :restaurant_owner
    visit restaurant_path(restaurant)
    within('nav') do
      fill_in 'Pesquisar', with: 'Carne'
      click_on 'Buscar'
    end

    expect(page).to have_content 'Carne moída'
    expect(page).to have_content 'Carne mal passada'
    expect(page).to have_content 'Churrasco'
    expect(page).not_to have_content 'Coca-cola'
  end

  it 'e vê tela de detalhes de um item' do
    new_item_in_menu('dish', 'Carne moída', 'Especial da casa', 30)

    login_as owner, scope: :restaurant_owner
    visit restaurant_path(restaurant)
    fill_in 'Pesquisar', with: 'Carne'
    click_on 'Buscar'
    click_on 'Carne moída'

    expect(page).to have_content 'Prato: Carne moída'
    expect(page).to have_content 'Especial da casa'
    expect(page).to have_content 'Calorias: 30'
  end

  it 'e vê tela de detalhes de um item' do
    login_as owner, scope: :restaurant_owner
    visit restaurant_path(restaurant)
    fill_in 'Pesquisar', with: 'Carne'
    click_on 'Buscar'

    expect(page).to have_content 'Não existem resultados disponíveis'
  end

  it 'e realiza busca em branco' do
    login_as owner, scope: :restaurant_owner
    visit restaurant_path(restaurant)
    fill_in 'Pesquisar', with: '  '
    click_on 'Buscar'

    expect(page).to have_content 'Valor de busca inválido'
  end

  it 'e só tem acesso ao do seu próprio Restaurante' do
    new_item_in_menu('dish', 'Carne moída', 'Especial da casa', 30)
    new_item_in_menu('dish', 'Carne mal passada', 'Carne bovina', 100)

    other_restaurant_owner = RestaurantOwner.create!(individual_tax_id: '86160052004', 
        name: 'Jhon', surname: 'Doe', email: 'dev2024@ruby.com',
        password: 'treina_dev13')
    other_restaurant = Restaurant.new(name: 'Toscana Code', brand_name: 'Toscana LTDA', register_number: '71.694.114/0001-27',
        comercial_phone: '(32) 4022-0000', email: 'fitdev@ruby.com', 
        restaurant_owner: other_restaurant_owner)
    other_restaurant_address = Address.create!(street: 'Av 13 de Brumário', number: '99', district: 'Cidade Nova',
        city: 'Pallet City', state: 'SP', zip_code: '72000-000', complement: '',
        user: other_restaurant, user_type: 'Restaurant')
    dish = other_restaurant.dishes.build
    dish.build_menu_item(
        name: 'Churrasco',
        description: 'Variadas opções de carne',
        calories: 100
      ).save!
    

    login_as other_restaurant_owner, scope: :restaurant_owner
    visit restaurant_path(other_restaurant)
    within('nav') do
      fill_in 'Pesquisar', with: 'Carne'
      click_on 'Buscar'
    end

    expect(page).not_to have_content 'Carne moída'
    expect(page).not_to have_content 'Carne mal passada'
    expect(page).to have_content 'Churrasco'
  end

  it 'deve estar autenticado' do
    visit root_path

    within('nav') do
      expect(page).not_to have_field 'Pesquisar'
    end
  end
end