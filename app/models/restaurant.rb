class Restaurant < ApplicationRecord
  has_one :address, as: :user, class_name: 'Address'
  belongs_to :restaurant_owner
  accepts_nested_attributes_for :address
end
