require 'rails_helper'

describe 'Proprietário atualiza seu horário de funcionamento' do
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
    BusinessHour.day_of_weeks.each do |key, _|
      restaurant.business_hours.create!(day_of_week: key, status: :open, open_time: '09:00',
          close_time: '17:00', restaurant: restaurant)
    end
    
    login_as owner, scope: :restaurant_owner
    visit restaurant_path(restaurant)
    click_on 'Segunda-feira de 09:00 às 17:00 (Aberto)'
    select 'Aberto', from: 'Funcionamento'
    fill_in 'Hora de Abertura', with: '12:35'
    fill_in 'Encerramento', with: '18:00'
    click_on 'Atualizar Horário'

    expect(page).to have_content 'Horário atualizado com sucesso'
    expect(page).to have_content 'Segunda-feira de 12:35 às 18:00 (Aberto)'
    expect(page).to have_content 'Terça-feira de 09:00 às 17:00 (Aberto)'
    expect(page).to have_content 'Quarta-feira de 09:00 às 17:00 (Aberto)'
    expect(page).to have_content 'Quinta-feira de 09:00 às 17:00 (Aberto)'
    expect(page).to have_content 'Sexta-feira de 09:00 às 17:00 (Aberto)'
    expect(page).to have_content 'Sábado de 09:00 às 17:00 (Aberto)'
    expect(page).to have_content 'Domingo de 09:00 às 17:00 (Aberto)'
  end

  it 'só pode editar dados do próprio Restaurante' do
    first_restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
        comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
        restaurant_owner: owner)
    first_restaurant_address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
        city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
        user: first_restaurant, user_type: 'Restaurant')

    first_restaurant_business_hour = first_restaurant.business_hours.create!(day_of_week: :monday, status: :open, open_time: '09:00',
        close_time: '17:00', restaurant: first_restaurant)

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
    visit edit_restaurant_business_hour_path(first_restaurant, first_restaurant_business_hour)

    expect(page).to have_content 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
    expect(page).not_to have_content 'Segunda-feira de 09:00 às 17:00'
    expect(page).not_to have_content 'Rua Passo Largo'
    expect(page).to have_content 'Toscana Code'
    expect(page).to have_content 'Av 13 de Brumário'
  end
end