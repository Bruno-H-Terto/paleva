require 'rails_helper'

RSpec.describe RestaurantOwner, type: :model do
  context '#valid?' do
    it 'todos os dados corretos' do
      restaurant_owner = RestaurantOwner.new(individual_tax_id: '91348691077', name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com', password: 'treina_dev13')
      
      expect(restaurant_owner).to be_valid
    end

    it 'CPF é obrigatório' do
      restaurant_owner = RestaurantOwner.new(individual_tax_id: '', name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com', password: 'treina_dev13')
      
      expect(restaurant_owner).not_to be_valid
    end

    it 'nome é obrigatório' do
      restaurant_owner = RestaurantOwner.new(individual_tax_id: '91348691077', name: '', surname: 'TDD', email: 'td13@ruby.com', password: 'treina_dev13')
      
      expect(restaurant_owner).not_to be_valid
    end

    it 'sobrenome é obrigatório' do
      restaurant_owner = RestaurantOwner.new(individual_tax_id: '91348691077', name: 'Ruby Dev', surname: '', email: 'td13@ruby.com', password: 'treina_dev13')
      
      expect(restaurant_owner).not_to be_valid
    end

    it 'CPF não pode ser repetido' do
      RestaurantOwner.create!(individual_tax_id: '91348691077', name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com', password: 'treina_dev13')

      restaurant_owner = RestaurantOwner.new(individual_tax_id: '91348691077', name: 'Rails New', surname: 'TD13', email: 'helloworld@rails.com', password: 'treina_dev13')
      
      expect(restaurant_owner).not_to be_valid
    end

    it 'CPF não pode ter mais que 11 caracteres' do
      restaurant_owner = RestaurantOwner.new(individual_tax_id: '913486910771', name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com', password: 'treina_dev13')
      
      expect(restaurant_owner).not_to be_valid
    end

    it 'CPF não pode ter menos que 11 caracteres' do
      restaurant_owner = RestaurantOwner.new(individual_tax_id: '9134869107', name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com', password: 'treina_dev13')
      
      expect(restaurant_owner).not_to be_valid
    end

    it 'CPF não pode ter letras' do
      restaurant_owner = RestaurantOwner.new(individual_tax_id: '9134A691077', name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com', password: 'treina_dev13')
      
      expect(restaurant_owner).not_to be_valid
    end

    it 'CPF não pode ter simbolos' do
      restaurant_owner = RestaurantOwner.new(individual_tax_id: '9134$691077', name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com', password: 'treina_dev13')
      
      expect(restaurant_owner).not_to be_valid
    end
  end

  context '#update' do
    it 'CPF não pode ser alterado' do
      restaurant_owner = RestaurantOwner.create!(individual_tax_id: '91348691077', name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com', password: 'treina_dev13')
      
      restaurant_owner.individual_tax_id = '14628577013'

      expect(restaurant_owner).not_to be_valid
    end

    it 'CPF retorna ao original' do
      restaurant_owner = RestaurantOwner.create!(individual_tax_id: '91348691077', name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com', password: 'treina_dev13')
      
      restaurant_owner.update individual_tax_id: '14628577013'

      expect(restaurant_owner.individual_tax_id).not_to eq '14628577013'
      expect(restaurant_owner.individual_tax_id).to eq '91348691077'
    end
  end
end
