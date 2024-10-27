class BeveragesController < ApplicationController
  before_action :authenticate_restaurant_owner!
  before_action :fetch_restaurant
  before_action :fetch_beverage, only: %i[show]

  def show; end

  def new
    @beverage = @restaurant.beverages.build
    @beverage.build_menu_item
  end

  def create
    @beverage = @restaurant.beverages.build(photo_params)
    @beverage.build_menu_item(beverage_params)

    if @beverage.save
      redirect_to restaurant_path(@restaurant), notice: "#{@beverage.menu_item.name} registrado com sucesso"
    else
      flash.now[:alert] = 'Não foi possível concluir a operação'
      render :new, status: :unprocessable_entity
    end
  end
  
  private

  def fetch_beverage
    @beverage = Beverage.find(params[:id])
    owner = current_restaurant_owner
    @restaurant = fetch_restaurant
    if @restaurant.restaurant_owner != owner
      return redirect_to Restaurant.find_by(restaurant_owner: owner), alert: 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
    end
  end

  def fetch_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def beverage_params
    params.require(:beverage).permit(
      :name, :description, :calories
    )
  end

  def photo_params
    params.require(:beverage).permit(
      :photo
    )
  end
end
