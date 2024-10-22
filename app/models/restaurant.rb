class Restaurant < ApplicationRecord
  has_one :address, as: :user, class_name: 'Address'
  belongs_to :restaurant_owner
  accepts_nested_attributes_for :address

  validates :name, :brand_name, :comercial_phone, :register_number,
            :email, presence: true

  validates_with TaxIdValidator, lenght: 14, field: :register_number, on: :create
end
