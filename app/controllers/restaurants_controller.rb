class RestaurantsController < ApplicationController
  before_action :restaurant_active, only: %i[new]
  before_action :fetch_restaurant_owner

  def new
    @restaurant = @owner.build_restaurant
    @restaurant.build_address
  end

  def create
    @restaurant = @owner.create_restaurant(restaurant_params)
    return redirect_to root_path, notice: t('restaurant.registration.success') if @restaurant.save

    flash[:alert] = t('restaurant.registration.failure')
    render :new
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