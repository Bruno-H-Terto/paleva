class PhoneValidator < ActiveModel::Validator
  def validate(record)
    field = options[:field]

    phone_validator(record, field)
  end

  private

  def phone_validator(record, field)
    if invalid_format_phone?(record, field)
      return record.errors.add(field, I18n.t('invalid_registration'))
    end
  end

  def invalid_format_phone?(record, field)
    number = record.send(field)
    digits = ''
    if number.match /\A[(]?(\d{2})[)]?[\ ]?(\d{4,5})[-\ ]?(\d{4})\z/
      digits = number.gsub(/()-/, '')
    else
      return record.errors.add(field, I18n.t('out_range_length', number: ))
    end

    false
  end
end