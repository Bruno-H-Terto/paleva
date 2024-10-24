class Restaurant < ApplicationRecord
  has_one :address, as: :user, class_name: 'Address'
  belongs_to :restaurant_owner
  accepts_nested_attributes_for :address

  validates :name, :brand_name, :comercial_phone, :register_number,
            :email, presence: true
  validates :register_number, uniqueness: true

  validates :email, format: { 
    with: /\A[a-z0-9]+([\.\-_][a-z0-9]+)*@[a-z0-9]+(-[a-z0-9]+)*(\.[a-z]{2,})+\z/i,
    message: 'must contain a valid email'
  }
  

  validates_with TaxIdValidator, lenght: 14, field: :register_number
end
