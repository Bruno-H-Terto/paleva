class BusinessHoursController < ApplicationController
  before_action :fetch_restaurant

  def new
    BusinessHour.day_of_weeks.each do |key, _|
      @restaurant.business_hours.build(day_of_week: key)
    end
  end
  

  def create
    adjust_status_values(params[:restaurant][:business_hours_attributes])
    
    if @restaurant.update(business_hours_params)
      redirect_to restaurant_path(@restaurant), notice: 'Horário registrado com sucesso'
    else
      render :new, alert: 'Não foi possível incluir horários'
    end
  end
  

  private

  def fetch_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id]) 
  end

  def business_hours_params
    params.require(:restaurant).permit(
      business_hours_attributes: [:id, :open_time, :close_time, :status, :day_of_week]
    )
  end  
  
  def adjust_status_values(business_hours_attributes)
    business_hours_attributes.each do |_, attributes|
      attributes[:status] = attributes[:status].to_i
    end
  end
end