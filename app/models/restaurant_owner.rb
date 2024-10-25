class RestaurantOwner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :restaurant

  has_many :business_hours
  validates :individual_tax_id, presence: true, uniqueness: true
  validates :name, :surname, presence: true
  validates_with TaxIdValidator, lenght: 11, field: :individual_tax_id, if: :restaurant_is_nil
  before_validation :individual_tax_id_not_can_be_update, on: :update



  private

  def individual_tax_id_not_can_be_update
    if individual_tax_id_changed?
      restore_individual_tax_id!
      return errors.add(:individual_tax_id, I18n.t('invalid_update', name: :individual_tax_id))
    end
  end

  def restaurant_is_nil
    restaurant.nil?
  end
end
