class Address < ApplicationRecord
  belongs_to :user, polymorphic: true
  validates :street, :number, :district, :city, :state, :zip_code, presence: true
  validates :number, numericality: { only_integer: true }
  validate :state_must_be_an_uf
  validates :zip_code, format: { 
    with: /\A[\d]{5}[-][\d]{3}\z/,
    message: 'deve ser em um formato válido'
  }

  UFS = ['AC', 'AL', 'AP', 'AM', 'BA',
   'CE', 'DF', 'ES', 'GO', 'MA', 'MT',
   'MS', 'MG', 'PA', 'PB', 'PR', 'PE',
   'PI', 'RJ', 'RN', 'RS', 'RO', 'RR',
   'SC', 'SP', 'SE', 'TO'].freeze

  private

  def state_must_be_an_uf
    unless UFS.include?(state)
      return errors.add(:state, 'deve ser uma UF')
    end
  end
end
