class Address < ApplicationRecord
  belongs_to :user, polymorphic: true
  validates :street, :number, :district, :city, :state, :zip_code, presence: true
end
