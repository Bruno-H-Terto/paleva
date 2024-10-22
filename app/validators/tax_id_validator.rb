class TaxIdValidator < ActiveModel::Validator
  def validate(record)
    if conditions(record)
      record.errors.add(:individual_tax_id, I18n.t('invalid_registration'))
      return
    end

    tax_id_without_validation = record.individual_tax_id[0..-3]
    first_validation = validation(sum_range(0, tax_id(tax_id_without_validation), tax_id_without_validation.length))
    second_validation = validation(sum_range(0, tax_id(tax_id_without_validation, first_validation), tax_id(tax_id_without_validation, first_validation).length))
    tax_id_validate = tax_id(tax_id_without_validation, (first_validation + second_validation))

    if tax_id_validate != record.individual_tax_id
      record.errors.add(:individual_tax_id, I18n.t('invalid_registration'))
    end
  end

  private

  def conditions(record)
    record.individual_tax_id.present? && (invalid_format?(record) || repeat_number?(record))
  end

  def repeat_number?(record)
    record.individual_tax_id.chars.uniq.length == 1
  end

  def invalid_format?(record)
    if record.individual_tax_id.length != 11
      record.errors.add(:individual_tax_id, I18n.t('out_range_length', number: record.individual_tax_id.length))
      return true
    elsif record.individual_tax_id.chars.any? { |char| char.match?(/\D/) }
      record.errors.add(:individual_tax_id, I18n.t('not_is_a_number'))
      return true
    end
    false
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
