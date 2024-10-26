require 'rails_helper'

describe 'Proprietário cadastra opções no menu' do
  let(:owner) { 
    RestaurantOwner.create!(individual_tax_id: '91348691077', 
    name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
    password: 'treina_dev13') 
  }
  context 'do tipo prato' do
    it 'com sucesso' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                      restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                                      city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                                      user: restaurant, user_type: 'Restaurant')

      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Registrar opção de prato'
      fill_in 'Nome', with: 'Bolinho de carne moída simples '
      fill_in 'Descrição', with: 'Um bolinho de carne moída simples, bem temperado e carnudo - a farinha de
                                   trigo é usada apenas para dar consistência à massa.  '
      fill_in 'Calorias', with: '29,7'
      attach_file 'Foto demonstrativa', Rails.root.join('spec', 'support', 'bolinho_de_carne_moida.jpg')
      click_on 'Cadastrar'

      expect(current_path).to eq restaurant_path(restaurant)
      expect(page).to have_content 'Bolinho de carne moída simples registrado com sucesso'
      within('#menu-list') do
        expect(page).to have_content 'Bolinho de carne moída simples'
        expect(page).to have_css('img[src*="bolinho_de_carne_moida.jpg"]')
      end
    end
    it 'e vê detalhes do prato' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                      restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                                      city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                                      user: restaurant, user_type: 'Restaurant')

      restaurant_dish = restaurant.dishes.create!
      restaurant_dish.photo.attach(
        io: StringIO.new("test image data"),
        filename: "bolinho_de_carne_moida.jpg",
        content_type: "image/jpg"
      )

      restaurant_dish.create_menu_item!(name: 'Carne moida simples', description:'Um bolinho de carne moída simples, bem temperado e 
                                      carnudo - a farinha de trigo é usada apenas para dar consistência à massa.', calories: ''
                                      )

      
      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Carne moida simples'

      expect(page).to have_content 'Prato: Carne moida simples'
      expect(page).to have_content 'Descrição: Um bolinho de carne moída simples, bem temperado e carnudo'
      expect(page).to have_content ' - a farinha de trigo é usada apenas para dar consistência à massa.'
      expect(page).to have_content 'Calorias: Não informado'
      expect(page).to have_css('img[src*="bolinho_de_carne_moida.jpg"]')
    end
      

    it 'e falha ao não incluir informações obrigatórias' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                      restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                                      city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                                      user: restaurant, user_type: 'Restaurant')

      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Registrar opção de prato'
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: 'Um bolinho de carne moída simples, bem temperado e carnudo - a farinha de
                                   trigo é usada apenas para dar consistência à massa.  '
      fill_in 'Calorias', with: '29,7'
      click_on 'Cadastrar'

      expect(page).to have_content 'Não foi possível concluir a operação'
      expect(page).to have_content 'Nome não pode ficar em branco'
    end

    it 'calorias é opcional' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                      restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                                      city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                                      user: restaurant, user_type: 'Restaurant')

      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Registrar opção de prato'
      fill_in 'Nome', with: 'Bolinho de carne moída simples '
      fill_in 'Descrição', with: 'Um bolinho de carne moída simples, bem temperado e carnudo - a farinha de
                                   trigo é usada apenas para dar consistência à massa.  '
      fill_in 'Calorias', with: ''
      click_on 'Cadastrar'

      expect(page).to have_content 'Bolinho de carne moída simples registrado com sucesso'
    end
  end

  context 'do tipo bebida' do
    it 'com sucesso' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                      restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                                      city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                                      user: restaurant, user_type: 'Restaurant')

      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Registrar opção de bebida'
      fill_in 'Nome', with: 'Vinho tinto Cabernet Sauvignon 750ml'
      fill_in 'Descrição', with: 'Vinho tinto de Uvas Cabernet Sauvignon, do Vale Central,
                                  Chile. Garrafa de 750ml. Teor alcoólico de 13,5% '
      fill_in 'Calorias', with: '580'
      click_on 'Cadastrar'

      expect(current_path).to eq restaurant_path(restaurant)
      expect(page).to have_content 'Vinho tinto Cabernet Sauvignon 750ml registrado com sucesso'
      within('#menu-list') do
        expect(page).to have_content 'Vinho tinto Cabernet Sauvignon 750ml'
      end
    end
  end
end