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
      click_on 'Criar Prato'

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

      restaurant_dish = restaurant.dishes.build
      menu_item = restaurant_dish.build_menu_item(
        name: 'Carne moida simples',
        description: 'Um bolinho de carne moída simples, bem temperado e carnudo. A farinha de trigo é usada apenas para dar consistência à massa.',
        calories: ''
      )
    
      restaurant_dish.save
      restaurant_dish.photo.attach(
          io: StringIO.new("test image data"),
          filename: "bolinho_de_carne_moida.jpg",
          content_type: "image/jpg"
                                        )

      
      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Carne moida simples'

      expect(page).to have_content 'Prato: Carne moida simples'
      expect(page).to have_content 'Descrição: Um bolinho de carne moída simples, bem temperado e carnudo. A farinha de trigo é usada apenas para dar consistência à massa.'
      expect(page).to have_content 'Calorias: Não informado'
      expect(page).to have_css('img[src*="bolinho_de_carne_moida.jpg"]')
    end
      
    it 'e só pode ver detalhes dos pratos do próprio Restaurante' do
      first_restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                              restaurant_owner: owner)
      first_restaurant_address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                              city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                              user: first_restaurant, user_type: 'Restaurant')
      first_restaurant_dish = first_restaurant.dishes.build
                                        
      first_restaurant_dish.build_menu_item(name: 'Carne moida simples', description:'Um bolinho de carne moída simples, bem temperado e 
                                              carnudo - a farinha de trigo é usada apenas para dar consistência à massa.', calories: ''
                                              )
      first_restaurant_dish.save

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
      visit restaurant_dish_path(first_restaurant, first_restaurant_dish)

      expect(page).to have_content 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
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
      click_on 'Criar Prato'

      expect(page).to have_content 'Não foi possível concluir a operação'
      expect(page).to have_content 'Nome não pode ficar em branco'
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
      fill_in 'Descrição', with: 'Vinho tinto de Uvas Cabernet Sauvignon, do Vale Central, Chile. Garrafa de 750ml. Teor alcoólico de 13,5%'
      fill_in 'Calorias', with: '580'
      click_on 'Criar Bebida'
  
      expect(current_path).to eq restaurant_path(restaurant)
      expect(page).to have_content 'Vinho tinto Cabernet Sauvignon 750ml registrado com sucesso'
      within('#menu-list') do
        expect(page).to have_content 'Vinho tinto Cabernet Sauvignon 750ml'
      end
    end
  
    it 'e vê detalhes da bebida' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                      restaurant_owner: owner)
      address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                                  city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                                  user: restaurant, user_type: 'Restaurant')
  
      restaurant_drink = restaurant.beverages.build
      menu_item = restaurant_drink.build_menu_item(
        name: 'Vinho tinto Cabernet Sauvignon 750ml',
        description: 'Vinho tinto de Uvas Cabernet Sauvignon, do Vale Central, Chile. Garrafa de 750ml. Teor alcoólico de 13,5%',
        calories: ''
      )
    
      restaurant_drink.save
      restaurant_drink.photo.attach(
        io: StringIO.new("test image data"),
        filename: "vinho_tinto_cabernet_sauvignon.jpeg",
        content_type: "image/jpg"
      )
  
      login_as owner, scope: :restaurant_owner
      visit restaurant_path(restaurant)
      click_on 'Vinho tinto Cabernet Sauvignon 750ml'
  
      expect(page).to have_content 'Bebida: Vinho tinto Cabernet Sauvignon 750ml'
      expect(page).to have_content 'Descrição: Vinho tinto de Uvas Cabernet Sauvignon, do Vale Central, Chile. Garrafa de 750ml. Teor alcoólico de 13,5%'
      expect(page).to have_content 'Calorias: Não informado'
      expect(page).to have_css('img[src*="vinho_tinto_cabernet_sauvignon.jpeg"]')
    end
    
    it 'e só pode ver detalhes das bebidas do próprio Restaurante' do
      first_restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                              comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                              restaurant_owner: owner)
      first_restaurant_address = Address.create!(street: 'Rua Passo Largo', number: '42', district: 'Bolsão',
                              city: 'Gotham City', state: 'MG', zip_code: '36000-000', complement: 'Caverna',
                              user: first_restaurant, user_type: 'Restaurant')
      first_restaurant_drink = first_restaurant.dishes.build
                                                  
      first_restaurant_drink.build_menu_item(name: 'Vinho tinto Cabernet Sauvignon 750ml', description:'Vinho tinto de Uvas Cabernet Sauvignon, do Vale Central, Chile. Garrafa de 750ml. Teor alcoólico de 13,5%', calories: ''
      )
      first_restaurant_drink.save
  
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
      visit restaurant_dish_path(first_restaurant, first_restaurant_drink)
  
      expect(page).to have_content 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
      expect(page).not_to have_content 'Rubistas'
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
      click_on 'Registrar opção de bebida'
      fill_in 'Nome', with: ''
      fill_in 'Descrição', with: 'Um vinho tinto de Uvas Cabernet Sauvignon, bem encorpado e saboroso.'
      fill_in 'Calorias', with: '29,7'
      click_on 'Criar Bebida'
  
      expect(page).to have_content 'Não foi possível concluir a operação'
      expect(page).to have_content 'Nome não pode ficar em branco'
    end
  end  
end