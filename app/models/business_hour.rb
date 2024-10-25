class BusinessHour < ApplicationRecord
  belongs_to :restaurant

  enum :status, { closed: 0, open: 1}
  enum :day_of_week, { monday: 0, tuesday: 1, wednesday: 2, thursday: 3, friday: 4, saturday: 5, sunday: 6 }

  validates :restaurant_id, uniqueness: { scope: :day_of_week }

  before_validation

  def display_hours
    if open?
      "#{I18n.t("day_of_week.#{day_of_week}")} de #{open_time} às #{close_time} (#{I18n.t status})"
    else
      "#{I18n.t("day_of_week.#{day_of_week}")} sem funcionamento (#{I18n.t status})"
    end
  end
end
