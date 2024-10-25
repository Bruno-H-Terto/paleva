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
      fill_in_hours_for_day('friday', '09:00', '17:00', 'uncheck')
      fill_in_hours_for_day('saturday', '', '', 'uncheck')
      fill_in_hours_for_day('sunday', '', '', 'uncheck')
      click_on 'Cadastrar'

      expect(current_path).to eq restaurant_path(restaurant)
      expect(page).to have_content 'Horário registrado com sucesso'
      expect(page).to have_content 'Segunda-feira de 09:00 às 17:00 (Aberto) - Editar'
      expect(page).to have_content 'Terça-feira de 09:00 às 17:00 (Aberto) - Editar'
      expect(page).to have_content 'Quarta-feira de 09:00 às 17:00 (Aberto) - Editar'
      expect(page).to have_content 'Quinta-feira de 09:00 às 17:00 (Aberto) - Editar'
      expect(page).to have_content 'Sexta-feira sem funcionamento (Fechado) - Editar'
      expect(page).to have_content 'Sábado sem funcionamento (Fechado) - Editar'
      expect(page).to have_content 'Domingo sem funcionamento (Fechado) - Editar'
    end

    it 'falha ao selecionar Funcionamento, mas não passar o horário' do
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
      fill_in_hours_for_day('tuesday', '', '', 'check')
      fill_in_hours_for_day('wednesday', '', '', 'check')
      click_on 'Cadastrar'

      expect(page).to have_content 'Não foi possível incluir seus horários, revise os campos abaixo:'
      expect(page).to have_content 'Segunda-feira - horários inválidos'
      expect(page).to have_content 'Terça-feira - horários inválidos'
      expect(page).to have_content 'Quarta-feira - horários inválidos'
    end
  end
end
