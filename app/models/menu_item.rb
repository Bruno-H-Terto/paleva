class MenuItem < ApplicationRecord
  belongs_to :option, polymorphic: true
  validates :name, :description, presence: true
end
