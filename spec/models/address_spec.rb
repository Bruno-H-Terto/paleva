require 'rails_helper'

RSpec.describe Address, type: :model do
  let(:owner) { 
    RestaurantOwner.create!(individual_tax_id: '91348691077', 
    name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
    password: 'treina_dev13') 
  }
  context '#valid?' do
    it { should belong_to(:user) }
    
    it 'todos os campos válidos' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: 'Av. TDD Ruby on Rails', number: 42, district: 'Rubista', city: 'Condado',
                            state: 'MG', zip_code: '36000-000', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      expect(address).to be_valid
    end

    it 'logradouro é obrigatório' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: '', number: 42, district: 'Rubista', city: 'Condado',
                            state: 'MG', zip_code: '36000-000', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      expect(address).not_to be_valid
    end

    it 'número é obrigatório' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: 'Av. TDD Ruby on Rails', number: '', district: 'Rubista', city: 'Condado',
                            state: 'MG', zip_code: '36000-000', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      expect(address).not_to be_valid
    end

    it 'bairro é obrigatório' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: 'Av. TDD Ruby on Rails', number: 42, district: '', city: 'Condado',
                            state: 'MG', zip_code: '36000-000', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      expect(address).not_to be_valid
    end

    it 'cidade é obrigatório' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: 'Av. TDD Ruby on Rails', number: 42, district: 'Rubista', city: '',
                            state: 'MG', zip_code: '36000-000', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      expect(address).not_to be_valid
    end

    it 'estado é obrigatório' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: 'Av. TDD Ruby on Rails', number: 42, district: 'Rubista', city: 'Condado',
                            state: '', zip_code: '36000-000', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      expect(address).not_to be_valid
    end

    it 'CEP é obrigatório' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: 'Av. TDD Ruby on Rails', number: 42, district: 'Rubista', city: 'Condado',
                            state: 'MG', zip_code: '', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      expect(address).not_to be_valid
    end

    it 'complemento é opcional' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: 'Av. TDD Ruby on Rails', number: 42, district: 'Rubista', city: 'Condado',
                            state: 'MG', zip_code: '36000-000', complement: '', user: restaurant, user_type: Restaurant)

      expect(address).to be_valid
    end

    it 'número não deve conter letras' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: 'Av. TDD Ruby on Rails', number: '42 - A', district: 'Rubista', city: 'Condado',
                            state: 'MG', zip_code: '36000-000', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      expect(address).not_to be_valid
    end

    it 'CEP deve ter formato correto' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: 'Av. TDD Ruby on Rails', number: 42, district: 'Rubista', city: 'Condado',
                            state: 'MG', zip_code: '3600-0000', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      expect(address).not_to be_valid
    end

    it 'CEP não deve ter conter mais que 8 dígitos' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: 'Av. TDD Ruby on Rails', number: 42, district: 'Rubista', city: 'Condado',
                            state: 'MG', zip_code: '36000-0000', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      expect(address).not_to be_valid
    end

    it 'CEP não deve ter conter menos que 8 dígitos' do
      restaurant = Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: owner)

      address = Address.new(street: 'Av. TDD Ruby on Rails', number: 42, district: 'Rubista', city: 'Condado',
                            state: 'MG', zip_code: '36000-00', complement: 'Loja 1', user: restaurant, user_type: Restaurant)

      expect(address).not_to be_valid
    end
  end
end
