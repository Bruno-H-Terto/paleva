class Restaurant < ApplicationRecord
  has_one :address, as: :user
  accepts_nested_attributes_for :address
  belongs_to :restaurant_owner
  has_many :business_hours
  accepts_nested_attributes_for :business_hours
  has_many :dishes
  has_many :beverages

  validates :name, :brand_name, :comercial_phone, :register_number,
            :email, presence: true
  validates :register_number, uniqueness: true

  validates :email, format: { 
    with: /\A[a-z0-9]+([\.\-_][a-z0-9]+)*@[a-z0-9]+(-[a-z0-9]+)*(\.[a-z]{2,})+\z/i,
    message: 'deve ser em um formato válido'
  }

  validates_with PhoneValidator, field: :comercial_phone, if: -> {comercial_phone.present?}
  validates_with TaxIdValidator, lenght: 14, field: :register_number

  before_validation :generate_code, on: :create
  before_validation :code_must_be_unchanged, on: :update

  protected

  def generate_code
    self.code = SecureRandom.alphanumeric(6).upcase
  end

  def code_must_be_unchanged
    if code_changed?
      restore_code!
      return errors.add(:code, I18n.t('invalid_update', name: :code))
    end
  end
end
