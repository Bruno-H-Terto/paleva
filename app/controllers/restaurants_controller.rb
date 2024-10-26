class RestaurantsController < ApplicationController
  before_action :restaurant_active, except: %i[create]
  before_action :authenticate_restaurant_owner!
  before_action :fetch_restaurant_owner

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
    render :new
  end

  def show
    @restaurant = @owner.restaurant
  end

  private

  def fetch_restaurant_owner
    @owner = current_restaurant_owner
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