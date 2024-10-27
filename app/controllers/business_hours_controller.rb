class BusinessHoursController < ApplicationController
  before_action :authenticate_restaurant_owner!
  before_action :fetch_restaurant
  before_action :fetch_business_hour, only: %i[edit update]

  def new
    BusinessHour.day_of_weeks.each do |key, _|
      @restaurant.business_hours.build(day_of_week: key)
    end
  end
  
  def create
    @business_hours = @restaurant.business_hours.build(business_hours_params[:business_hours_attributes].values)
    @business_hours.each {|business_hour| business_hour.validate}

    if @business_hours.all?(&:valid?)
      if @business_hours.all? { |day| day.closed? }
        flash.now[:alert] = 'Selecione ao menos um dia de funcionamento'
        render :new, status: :unprocessable_entity
        return
      end

      @business_hours.each {|business_hour| business_hour.save}
      redirect_to restaurant_path(@restaurant), notice: 'Horário registrado com sucesso'
    else
      flash.now[:alert] = 'Não foi possível incluir seus horários, revise os campos abaixo:'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @business_hour.update(params_business_hour)
      return redirect_to restaurant_path(@restaurant), notice: 'Horário atualizado com sucesso'
    end

    flash.now[:alert] = 'Não foi possível concluir esta operação'
    render :edit, status: :unprocessable_entity
  end

  private

  def fetch_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id]) 
  end

  def business_hours_params
    params.require(:restaurant).permit(
      business_hours_attributes: [permied_params]
    )
  end

  def params_business_hour
    params.require(:business_hour).permit(
      permied_params.each {|param| param}
    )
  end

  def permied_params
    pemited = [:id, :open_time, :close_time, :status, :day_of_week]
  end

  def fetch_business_hour
    @business_hour = BusinessHour.find(params[:id])
    owner = current_restaurant_owner
    @restaurant = fetch_restaurant
    if @restaurant.restaurant_owner != owner
      return redirect_to Restaurant.find_by(restaurant_owner: owner), alert: 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
    end
  end
end