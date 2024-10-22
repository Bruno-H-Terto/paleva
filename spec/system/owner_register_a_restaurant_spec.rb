require 'rails_helper'

describe 'Proprietário acessa tela de registro' do
  context 'autenticado' do
    let(:owner) { 
                  RestaurantOwner.create!(individual_tax_id: '91348691077', 
                  name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
                  password: 'treina_dev13') 
                }

    it 'e cadastra seu restaurante' do
      login_as owner, scope: :restaurant_owner
      visit new_restaurant_path
      fill_in 'Nome', with: 'Entregas TD13'
      fill_in 'Razão social', with: 'TD & Devs Ruby LTDA'
      fill_in 'CNPJ', with: '89078820000100'
      fill_in 'Telefone', with: '(32) 4022-8922'
      fill_in 'E-mail', with: 'podraodev@ruby.com'
      fill_in 'Logradouro', with: 'Av. TDD Ruby on Rails'
      fill_in 'Número', with: '42'
      fill_in 'Bairro', with: 'Rubista'
      fill_in 'Cidade', with: 'Condado'
      fill_in 'Estado', with: 'MG'
      fill_in 'CEP', with: '3600-000'
      fill_in 'Complemento', with: 'Loja 1'
      click_on 'Cadastrar'

      expect(page).to have_content 'Restaurante registrado realizado com sucesso'
    end

    it 'e falha ao cadastrar restaurante' do
      login_as owner, scope: :restaurant_owner
      visit new_restaurant_path
      fill_in 'Nome', with: 'Entregas TD13'
      fill_in 'Razão social', with: 'TD & Devs Ruby LTDA'
      fill_in 'CNPJ', with: '89078820000100'
      fill_in 'Telefone', with: '(32) 4022-8922'
      fill_in 'E-mail', with: 'podraodev@ruby.com'
      fill_in 'Logradouro', with: 'Av. TDD Ruby on Rails'
      fill_in 'Número', with: ''
      fill_in 'Bairro', with: 'Rubista'
      fill_in 'Cidade', with: 'Condado'
      fill_in 'Estado', with: 'MG'
      fill_in 'CEP', with: '3600-000'
      fill_in 'Complemento', with: 'Loja 1'
      click_on 'Cadastrar'

      expect(page).to have_content 'Não foi possível registrar o Restaurante'
      expect(Restaurant.count).to eq 0
      expect(Address.count).to eq 0
    end
    
  end
end