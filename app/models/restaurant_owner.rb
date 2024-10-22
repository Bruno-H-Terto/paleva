class RestaurantOwner < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :individual_tax_id, presence: true, uniqueness: true
  validates :name, :surname, presence: true
  before_validation :individual_tax_id_must_be_valid, on: :create


  private

  def individual_tax_id_must_be_valid
    return errors.add(:individual_tax_id, I18n.t('invalid_registration')) if self.individual_tax_id.present? && is_a_number && repeat_number 

    tax_id_without_validation = self.individual_tax_id[0..-3]
    first_validation = validation(sum_range(0, tax_id(tax_id_without_validation), tax_id_without_validation.length))
    second_validation = validation(sum_range(0,tax_id(tax_id_without_validation, first_validation) , tax_id(tax_id_without_validation, first_validation).length))
    tax_id_validate = tax_id(tax_id_without_validation, (first_validation + second_validation))

    if tax_id_validate != self.individual_tax_id
      errors.add(:individual_tax_id, I18n.t('invalid_registration')) 
    end
  end

  def repeat_number
    self.individual_tax_id.chars.uniq.length == 1
  end

  def is_a_number
    if self.individual_tax_id.length != 11
      return errors.add(:individual_tax_id, I18n.t('out_range_length', number: self.individual_tax_id.length))
    end

    self.individual_tax_id.chars.exclude?(/\D/)
  end

  def sum_range(validation_number, tax_id, position_tx_id, index = 0)
    validation_number += tax_id[index].to_i * (position_tx_id + 1)
    position_tx_id -= 1
    index += 1

    return sum_range(validation_number, tax_id, position_tx_id, index) if position_tx_id > 0

    validation_number
  end

  def tax_id(tax_id_without_validation_number, validation_number = nil)
    return tax_id_without_validation_number + validation_number.to_s if validation_number.present?
  
    tax_id_without_validation_number
  end
  
  def validation(result)
    if result % 11 < 2
      '0'
    else
      (11 - result % 11).to_s
    end
  end
end
