require 'rails_helper'

RSpec.describe MenuItem, type: :model do
  let(:owner) { 
    RestaurantOwner.create!(individual_tax_id: '91348691077', 
    name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
    password: 'treina_dev13') 
  }
  let(:restaurant) {
    Restaurant.new(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
    comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
    restaurant_owner: owner)
  }

  context '#valid?' do
    it { should belong_to(:option) }

    it 'todos os campos validos' do
      restaurant_dish = restaurant.dishes.build
      menu_item = restaurant_dish.build_menu_item(
        name: 'Carne moida simples',
        description: 'Um bolinho de carne moída simples, bem temperado e carnudo. A farinha de trigo é usada apenas para dar consistência à massa.',
        calories: 30
      )

      expect(menu_item).to be_valid
    end

    it 'nome é obrigatório' do
      restaurant_dish = restaurant.dishes.build
      menu_item = restaurant_dish.build_menu_item(
        name: '',
        description: 'Um bolinho de carne moída simples, bem temperado e carnudo. A farinha de trigo é usada apenas para dar consistência à massa.',
        calories: 30
      )

      expect(menu_item).not_to be_valid
    end

    it 'Descrição é obrigatório' do
      restaurant_dish = restaurant.dishes.build
      menu_item = restaurant_dish.build_menu_item(
        name: 'Carne moida simples',
        description: '',
        calories: 30
      )

      expect(menu_item).not_to be_valid
    end

    it 'calorias é opcional' do
      restaurant_dish = restaurant.dishes.build
      menu_item = restaurant_dish.build_menu_item(
        name: 'Carne moida simples',
        description: 'Um bolinho de carne moída simples, bem temperado e carnudo. A farinha de trigo é usada apenas para dar consistência à massa.',
        calories: ''
      )

      expect(menu_item).to be_valid
    end

    it 'pertence a pratos e bebidas' do
      restaurant_dish = restaurant.dishes.build
      menu_item = restaurant_dish.build_menu_item(
        name: 'Carne moida simples',
        description: 'Um bolinho de carne moída simples, bem temperado e carnudo. A farinha de trigo é usada apenas para dar consistência à massa.',
        calories: ''
      )

      restaurant_drink = restaurant.beverages.build
      menu_item = restaurant_drink.build_menu_item(
        name: 'Vinho tinto Cabernet Sauvignon 750ml',
        description: 'Vinho tinto de Uvas Cabernet Sauvignon, do Vale Central, Chile. Garrafa de 750ml. Teor alcoólico de 13,5%',
        calories: 30
      )

      expect(restaurant_dish).to be_valid
      expect(restaurant_drink).to be_valid
    end

    it 'armazena pratos e bebidas' do
      restaurant_dish = restaurant.dishes.build
      menu_dish = restaurant_dish.build_menu_item(
        name: 'Carne moida simples',
        description: 'Um bolinho de carne moída simples, bem temperado e carnudo. A farinha de trigo é usada apenas para dar consistência à massa.',
        calories: ''
      )
      restaurant_dish.save

      restaurant_drink = restaurant.beverages.build
      menu_drink = restaurant_drink.build_menu_item(
        name: 'Vinho tinto Cabernet Sauvignon 750ml',
        description: 'Vinho tinto de Uvas Cabernet Sauvignon, do Vale Central, Chile. Garrafa de 750ml. Teor alcoólico de 13,5%',
        calories: 30
      )
      restaurant_drink.save

      expect(MenuItem.count).to eq 2
      expect(Dish.last).to eq restaurant_dish
      expect(Beverage.last).to eq restaurant_drink
      expect(MenuItem.first).to eq menu_dish
      expect(MenuItem.last).to eq menu_drink
    end

    it 'não gera prato ou bebida se não for salvo também' do
      restaurant_dish = restaurant.dishes.build
      restaurant_dish.save
      restaurant_drink = restaurant.beverages.build
      restaurant_drink.save


      expect(MenuItem.count).to eq 0
      expect(Dish.count).to eq 0
      expect(Beverage.count).to eq 0
    end
  end
end
