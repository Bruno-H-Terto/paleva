require 'rails_helper'

describe 'Proprietário edita seu Restaurante' do
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
      click_on 'Editar dados do Restaurante'
      fill_in 'Nome', with: 'Entregas TD13 & CIA'
      fill_in 'Razão social', with: 'TD & Devs Ruby LTDA'
      fill_in 'CNPJ', with: '70.237.330/0001-80'
      fill_in 'Telefone', with: '(32) 4022-5800'
      fill_in 'E-mail', with: 'lanchedev@ruby.com'
      click_on 'Atualizar Restaurante'

      expect(page).to have_content 'Restaurante atualizado com sucesso'
      expect(page).to have_css 'nav', text: 'Ruby Dev - td13@ruby.com'
      expect(page).to have_content "Entregas TD13 & CIA - #{Restaurant.last.code}"
      expect(page).to have_content 'Rua Passo Largo, 42'
      expect(page).to have_content 'Bolsão'
      expect(page).to have_content 'Caverna'
      expect(page).to have_content 'Gotham City, MG'
      expect(page).to have_content '36000-000'
    end

    it 'e falha por não preencher campos obrigatórios' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                      restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                                  city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                                  user: restaurant, user_type: 'Restaurant')

      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Editar dados do Restaurante'
      fill_in 'Nome', with: ''
      fill_in 'Razão social', with: 'TD & Devs Ruby LTDA'
      fill_in 'CNPJ', with: '70.237.330/0001'
      fill_in 'Telefone', with: '(32) 4022-580054'
      fill_in 'E-mail', with: 'lanchedev@ruby'
      click_on 'Atualizar Restaurante'

      expect(page).to have_content 'Não foi possível atualizar o Restaurante'
      expect(page).to have_content 'Nome não pode ficar em branco'
      expect(page).to have_content 'Telefone número de digitos incorretos: digitado (32) 4022580054'
      expect(page).to have_content 'E-mail deve ser em um formato válido'
      expect(page).to have_content 'Telefone não é um registro válido'
      expect(page).to have_content 'CNPJ número de digitos incorretos: digitado 15'
      expect(page).to have_content 'CNPJ não é um registro válido'
    end
  end
end