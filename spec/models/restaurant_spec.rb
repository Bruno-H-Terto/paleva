require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  context '#valid?' do
    let(:owner) { 
      RestaurantOwner.create!(individual_tax_id: '91348691077', 
      name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
      password: 'treina_dev13') 
    }

    it 'todos os campos validos' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)

      expect(restaurant).to be_valid
    end
    
    it 'nome é obrigatório' do
      restaurant = Restaurant.new(name: '', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)

      expect(restaurant).not_to be_valid
    end

    it 'razão social é obrigatório' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: '', register_number: '89078820000100',
      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)

      expect(restaurant).not_to be_valid
    end

    it 'CNPJ é obrigatório' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '',
      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)

      expect(restaurant).not_to be_valid
    end

    it 'CNPJ pode ter pontos, hífen e barra' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89.078.820/0001-00',
      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)

      expect(restaurant).to be_valid
    end

    it 'Telefone é obrigatório' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
      comercial_phone: '', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)

      expect(restaurant).not_to be_valid
    end

    it 'email é obrigatório' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
      comercial_phone: '(32) 4022-8922', email: '', 
      restaurant_owner: owner)

      expect(restaurant).not_to be_valid
    end

    it 'CNPJ deve ser válido' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '19078820000100',
      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)

      expect(restaurant).not_to be_valid
    end

    it 'CNPJ não pode ter mais que 14 caracteres numéricos' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '890788200001001',
      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)

      expect(restaurant).not_to be_valid
    end  

    it 'CNPJ não pode ter menos que 14 caracteres numéricos' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '8907882000010',
      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)

      expect(restaurant).not_to be_valid
    end

    it 'CNPJ não pode ter letras' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '890788200A0100',
      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)

      expect(restaurant).not_to be_valid
    end

    it 'CNPJ não pode ter simbolos' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '890788200%01001',
      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)

      expect(restaurant).not_to be_valid
    end

    it 'CNPJ deve ser único, caso outro CPF tente realizar o mesmo cadastro' do
      other_tax_id_owner = RestaurantOwner.create!(individual_tax_id: '86160052004', 
                                                    name: 'Ruby Dev', surname: 'TDD', email: 'dev2024@ruby.com',
                                                    password: 'treina_dev13')
      first_restaurant = Restaurant.create!(name: 'Devzeiros', brand_name: 'Rails Work LTDA', register_number: '89078820000100',
                                            comercial_phone: '(32) 4022-0000', email: 'lightdev@ruby.com', 
                                            restaurant_owner: owner)

      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
                                  restaurant_owner: other_tax_id_owner)

      expect(restaurant).not_to be_valid
    end

    it 'email deve ser um registro válido' do
      restaurant = Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
                                  comercial_phone: '(32) 4022-8922', email: 'ruby@email', 
                                  restaurant_owner: owner)

      expect(restaurant).not_to be_valid
    end
  end
end
