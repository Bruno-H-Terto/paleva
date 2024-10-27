require 'rails_helper'

RSpec.describe Beverage, type: :model do
  context '#valid?' do
    it { should have_one(:menu_item)}
    it { should belong_to(:restaurant)}
    it { should validate_presence_of(:menu_item) }
    it { should accept_nested_attributes_for(:menu_item) }

    it 'deve ter um menu item' do
      beverage = Beverage.new
      beverage.valid?
      expect(beverage).not_to be_valid
      expect(beverage.errors[:menu_item]).to include('não pode ficar em branco')
    end
  end
end
