require 'rails_helper'

describe 'Usuário acessa área do Proprietário' do
  let(:owner) {
    RestaurantOwner.create!(individual_tax_id: '91348691077', 
                             name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
                             password: 'treina_dev13') 
  }

  context 'estando autenticado' do
    def fill_in_hours_for_day(day, open_time, close_time, check)
      within "##{day}" do
        if check == 'check'
          check 'Funcionamento'
        end
        fill_in 'Hora de Abertura', with: open_time
        fill_in 'Encerramento', with: close_time
      end
    end

    it 'e registra seu horário de funcionamento' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                      restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                                city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                                user: restaurant, user_type: 'Restaurant')

      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Cadastrar horário de funcionamento'
      
      fill_in_hours_for_day('monday', '09:00', '17:00', 'check')
      fill_in_hours_for_day('tuesday', '09:00', '17:00', 'check')
      fill_in_hours_for_day('wednesday', '09:00', '17:00', 'check')
      fill_in_hours_for_day('thursday', '09:00', '17:00', 'check')
      fill_in_hours_for_day('friday', '09:00', '17:00', 'check')
      fill_in_hours_for_day('saturday', '09:00', '17:00', 'check')
      fill_in_hours_for_day('sunday', '09:00', '17:00', 'check')
      click_on 'Cadastrar'

      expect(current_path).to eq restaurant_path(restaurant)
      expect(page).to have_content 'Horário registrado com sucesso'
      expect(page).to have_content 'Segunda-feira de 09:00 às 17:00 (Aberto) - Editar'
      expect(page).to have_content 'Terça-feira de 09:00 às 17:00 (Aberto) - Editar'
      expect(page).to have_content 'Quarta-feira de 09:00 às 17:00 (Aberto) - Editar'
      expect(page).to have_content 'Quinta-feira de 09:00 às 17:00 (Aberto) - Editar'
      expect(page).to have_content 'Sexta-feira de 09:00 às 17:00 (Aberto) - Editar'
      expect(page).to have_content 'Sábado de 09:00 às 17:00 (Aberto) - Editar'
      expect(page).to have_content 'Domingo de 09:00 às 17:00 (Aberto) - Editar'
    end

    it 'falha ao selecionar Funcionamento, mas não passa o horário' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                      restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                                city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                                user: restaurant, user_type: 'Restaurant')

      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Cadastrar horário de funcionamento'
      
      fill_in_hours_for_day('monday', '', '', 'check')
      fill_in_hours_for_day('tuesday', '09:00', '', 'check')
      fill_in_hours_for_day('wednesday', '', '17:00', 'check')
      click_on 'Cadastrar'

      expect(BusinessHour.count).to eq 0
      expect(page).to have_content 'Não foi possível incluir seus horários, revise os campos abaixo:'
      expect(page).to have_content 'Segunda-feira - horários inválidos'
      expect(page).to have_content 'Terça-feira - horários inválidos'
      expect(page).to have_content 'Quarta-feira - horários inválidos'
    end

    it 'todos vazios' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                      restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                                city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                                user: restaurant, user_type: 'Restaurant')

      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Cadastrar horário de funcionamento'
      click_on 'Cadastrar'

      expect(page).to have_content 'Selecione ao menos um dia de funcionamento'
    end

    it 'e só pode ver informações do próprio Restaurante' do
      first_restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                              restaurant_owner: owner)
      first_restaurant_address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                              city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                              user: first_restaurant, user_type: 'Restaurant')

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
      visit restaurant_path(first_restaurant)

      expect(page).to have_content 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
      expect(page).not_to have_content 'Rubistas'
      expect(page).not_to have_content 'Rua Passo Largo'
      expect(page).to have_content 'Toscana Code'
      expect(page).to have_content 'Av 13 de Brumário'
    end
  end
end
