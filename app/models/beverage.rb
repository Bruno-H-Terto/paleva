class Beverage < ApplicationRecord
  belongs_to :restaurant
  has_one :menu_item, as: :option
  accepts_nested_attributes_for :menu_item
  has_one_attached :photo
  validates :menu_item, presence: true
end
