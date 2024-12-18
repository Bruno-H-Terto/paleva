class BusinessHour < ApplicationRecord
  belongs_to :restaurant

  enum :status, { closed: 0, open: 1}
  enum :day_of_week, { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }
  validate :presence_hour
  validates :day_of_week, uniqueness: {scope: :restaurant_id}
  validate :close_time_must_be_greater_or_equal


  def display_hours
    if open?
      "#{I18n.t("day_of_week.#{day_of_week}")} de #{I18n.l(open_time, format: "%H:%M")} às #{I18n.l(close_time, format: "%H:%M")} (#{I18n.t status})"
    else
      "#{I18n.t("day_of_week.#{day_of_week}")} sem funcionamento (#{I18n.t status})"
    end
  end

  private

  def close_time_must_be_greater_or_equal
    return if close_time.blank? || open_time.blank?

    if close_time < open_time
      errors.add(:close_time, 'deve ser posterior ou igual ao horário de abertura')
    end
  end

  def presence_hour
    if open? && (open_time.blank? || close_time.blank?)
      errors.add(:base, "#{I18n.t("day_of_week.#{day_of_week}")} - horários inválidos")
    end
  end
end
