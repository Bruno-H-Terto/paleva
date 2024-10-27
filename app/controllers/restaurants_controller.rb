class RestaurantsController < ApplicationController
  before_action :restaurant_active, except: %i[create]
  before_action :authenticate_restaurant_owner!
  before_action :fetch_restaurant_owner
  before_action :fetch_restaurant, only: %i[show edit update]

  def new
    return redirect_to root_path, notice: 'Restaurante já cadastrado' if @owner.restaurant.present?

    @restaurant = @owner.build_restaurant
    @restaurant.build_address
  end

  def create
    @restaurant = @owner.create_restaurant(restaurant_params)

    if @restaurant.save
      return redirect_to restaurant_path(@restaurant), notice: t('restaurant.registration.success')
    end
    flash[:alert] = t('restaurant.registration.failure')
    render :new, status: :unprocessable_entity
  end

  def show; end

  def edit
    @restaurant.address
  end

  def update
    if @restaurant.update(restaurant_params)
      return redirect_to restaurant_path(@restaurant), notice: t('restaurant.update.success')
    end
    flash[:alert] = t('restaurant.update.failure')
    render :new, status: :unprocessable_entity
  end

  private

  def fetch_restaurant_owner
    @owner = current_restaurant_owner
  end

  def fetch_restaurant
    owner = fetch_restaurant_owner
    @restaurant = Restaurant.find(params[:id])
    if @restaurant.restaurant_owner != owner
      return redirect_to Restaurant.find_by(restaurant_owner: owner), alert: 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
    end
  end

  def restaurant_params
    params.require(:restaurant).permit(
      :name,
      :brand_name,
      :register_number,
      :comercial_phone,
      :email,
      address_attributes: %i[street number district city state zip_code complement]
    )
  end
end