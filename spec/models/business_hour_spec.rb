require 'rails_helper'

RSpec.describe BusinessHour, type: :model do
  context '#valid?' do
    let(:owner) { 
      RestaurantOwner.create!(individual_tax_id: '91348691077', 
      name: 'Ruby Dev', surname: 'TDD', email: 'td13@ruby.com',
      password: 'treina_dev13') 
    }

    let(:restaurant){
      Restaurant.create!(name: 'Rubistas', brand_name: 'Ruby Work LTDA', register_number: '89078820000100',
      comercial_phone: '(32) 4022-8922', email: 'podraodev@ruby.com', 
      restaurant_owner: owner)
    }

    it 'todos os campos válidos' do
      business_hour = BusinessHour.new(day_of_week: :monday, status: :open, open_time: '07:00',
                                       close_time: '12:00', restaurant: restaurant)

      expect(business_hour).to be_valid
    end

    it 'dia da semana só pode ter um expediente' do
      first_business_hour = BusinessHour.create!(day_of_week: :monday, status: :open, open_time: '07:00',
                                       close_time: '12:00', restaurant: restaurant)

      second_business_hour = BusinessHour.new(day_of_week: :monday, status: :open, open_time: '18:00',
                                       close_time: '21:00', restaurant: restaurant)        

      expect(second_business_hour).not_to be_valid
    end  
    
    context '.open' do
      it 'hora de abertura é obrigatório' do
        business_hour = BusinessHour.new(day_of_week: :monday, status: :open, open_time: '',
                                        close_time: '12:00', restaurant: restaurant)

        expect(business_hour).not_to be_valid
      end

      it 'hora de encerramento é obrigatório' do
        business_hour = BusinessHour.new(day_of_week: :monday, status: :open, open_time: '07:00',
                                        close_time: '', restaurant: restaurant)

        expect(business_hour).not_to be_valid
      end    
    end

    context '.closed' do
      it 'horários são opcionais' do
        business_hour = BusinessHour.new(day_of_week: :monday, status: :closed, open_time: '',
                                         close_time: '', restaurant: restaurant)
  
        expect(business_hour).to be_valid
      end
    end
  end
end
