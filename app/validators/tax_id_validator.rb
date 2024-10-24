class TaxIdValidator < ActiveModel::Validator
  def validate(record)
    lenght = options[:lenght]
    field = options[:field]

    if record.send(field).match(/\A(\d){3}[.](\d){3}[.](\d){3}[-](\d){2}$/)
      digits = record.send(field).gsub(/[.-]/, '')
    elsif record.send(field).match(/\A(\d){2}[.](\d){3}[.](\d){3}[\/](\d){4}[-](\d){2}$/)
      digits = record.send(field).gsub(/[\/.-]/, '')
    else
      digits = record.send(field)
    end
    
    validate_tax_id(record, field, lenght, digits)
  end

  private

  def validate_tax_id(record, field, expected_length, digits)
    if tax_id_conditions(record, field, expected_length, digits)
      record.errors.add(field, I18n.t('invalid_registration'))
      return
    end

    tax_id_without_validation = digits[0..-3]
    first_validation = calculate_validation(tax_id_without_validation)
    second_validation = calculate_validation(tax_id_without_validation + first_validation)
    validated_tax_id = tax_id_without_validation + first_validation + second_validation

    if validated_tax_id != digits
      record.errors.add(field, I18n.t('invalid_registration'))
    end
  end

  def tax_id_conditions(record, field, expected_length, value)
    value.present? && (invalid_format?(record, field, expected_length, value) || repeat_number?(value))
  end

  def invalid_format?(record, field, expected_length, value)
    if value.length != expected_length
      record.errors.add(field, I18n.t('out_range_length', number: value.length))
      return true
    elsif value.chars.any? { |char| char.match?(/\D/) }
      record.errors.add(field, I18n.t('not_is_a_number'))
      return true
    end
    false
  end

  def calculate_validation(tax_id_without_validation)
    if tax_id_without_validation.length <= 10
      validation_number = validation(sum_range(0, tax_id_without_validation, tax_id_without_validation.length))
    else
      first_part = tax_id_without_validation[0..-9]
      second_part = tax_id_without_validation[-8..-1]

      validation_number = validation(
        sum_range(0, first_part, first_part.length) +
        sum_range(0, second_part, second_part.length)
      )
    end
    validation_number
  end

  def repeat_number?(value)
    value.chars.uniq.length == 1
  end

  def sum_range(validation_number, tax_id, remaining_digits, index = 0)
    validation_number += tax_id[index].to_i * (remaining_digits + 1)
    remaining_digits -= 1
    index += 1

    return sum_range(validation_number, tax_id, remaining_digits, index) if remaining_digits > 0

    validation_number
  end

  def validation(result)
    (result % 11 < 2) ? '0' : (11 - result % 11).to_s
  end
end