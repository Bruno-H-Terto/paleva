class Restaurant < ApplicationRecord
  has_one :address, as: :user, class_name: 'Address'
  belongs_to :restaurant_owner
  accepts_nested_attributes_for :address
  has_many :business_hours
  accepts_nested_attributes_for :business_hours

  validates :name, :brand_name, :comercial_phone, :register_number,
            :email, presence: true
  validates :register_number, uniqueness: true

  validates :email, format: { 
    with: /\A[a-z0-9]+([\.\-_][a-z0-9]+)*@[a-z0-9]+(-[a-z0-9]+)*(\.[a-z]{2,})+\z/i,
    message: 'deve ser em um formato válido'
  }

  validates_with PhoneValidator, field: :comercial_phone
  validates_with TaxIdValidator, lenght: 14, field: :register_number

  before_validation :generate_code, on: :create


  protected

  def generate_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end
end
