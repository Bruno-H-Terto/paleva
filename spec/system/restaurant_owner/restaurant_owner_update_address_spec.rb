require 'rails_helper'

describe 'Proprietário atualiza seu endereço' do
  context 'autenticado' do
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

      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Editar Endereço'
      fill_in 'Logradouro', with: 'Av. TDD Ruby on Rails'
      fill_in 'Número', with: '42'
      fill_in 'Bairro', with: 'Rubista'
      fill_in 'Cidade', with: 'Condado'
      fill_in 'Estado', with: 'MG'
      fill_in 'CEP', with: '36000-000'
      fill_in 'Complemento', with: 'Loja 1'
      click_on 'Atualizar Endereço'

      expect(page).to have_content 'Endereço atualizado com sucesso'
      expect(page).to have_css 'nav', text: 'Ruby Dev - td13@ruby.com'
      expect(page).to have_content "Rubistas - #{Restaurant.last.code}"
      expect(page).to have_content 'Av. TDD Ruby on Rails, 42'
      expect(page).to have_content 'Loja 1'
      expect(page).to have_content 'Rubista'
      expect(page).to have_content 'Condado, MG'
      expect(page).to have_content '36000-000'
    end

    it 'e falha ao não inserir informações obrigatórias' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                        comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                        restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                        city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                        user: restaurant, user_type: 'Restaurant')

      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Editar Endereço'
      fill_in 'Logradouro', with: ''
      fill_in 'Número', with: '42 - A'
      fill_in 'Bairro', with: 'Rubista'
      fill_in 'Cidade', with: 'Condado'
      fill_in 'Estado', with: 'Minas Gerais'
      fill_in 'CEP', with: '36000-0000'
      fill_in 'Complemento', with: 'Loja 1'
      click_on 'Atualizar Endereço'

      expect(page).to have_content 'Não foi possível atualizar seu Endereço'
      expect(page).to have_content 'Logradouro não pode ficar em branco'
      expect(page).to have_content 'Número não é um número'
      expect(page).to have_content 'Estado deve ser uma UF'
      expect(page).to have_content 'CEP deve ser em um formato válido'
    end

    it 'e só pode acessar dados do próprio Restaurante' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                        comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                        restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                        city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                        user: restaurant, user_type: 'Restaurant')
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
      visit edit_restaurant_address_path(restaurant, address)

      expect(current_path).to eq restaurant_path(other_restaurant)
      expect(page).to have_content 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
      expect(page).not_to have_content 'Rubistas'
      expect(page).not_to have_content 'Rua Passo Largo'
      expect(page).to have_content 'Toscana Code'
      expect(page).to have_content 'Av 13 de Brumário'
    end
  end
end