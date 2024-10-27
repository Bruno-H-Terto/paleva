class DishesController < ApplicationController
  before_action :authenticate_restaurant_owner!
  before_action :fetch_restaurant
  before_action :fetch_dish, only: %i[show]

  def show; end

  def new
    @dish = @restaurant.dishes.build
    @dish.build_menu_item
  end

  def create
    @dish = @restaurant.dishes.build(photo_params)
    @dish.build_menu_item(dish_params)

    if @dish.save
      redirect_to restaurant_path(@restaurant), notice: "#{@dish.menu_item.name} registrado com sucesso"
    else
      flash.now[:alert] = 'Não foi possível concluir a operação'
      render :new, status: :unprocessable_entity
    end
  end
  
  private

  def fetch_dish
    @dish = Dish.find(params[:id])
    owner = current_restaurant_owner
    @restaurant = fetch_restaurant
    if @restaurant.restaurant_owner != owner
      return redirect_to Restaurant.find_by(restaurant_owner: owner), alert: 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
    end
  end

  def fetch_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def dish_params
    params.require(:dish).permit(
      :name, :description, :calories
    )
  end

  def photo_params
    params.require(:dish).permit(
      :photo
    )
  end
end
