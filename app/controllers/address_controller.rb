class AddressController < ApplicationController
  before_action :authenticate_restaurant_owner!
  before_action :fetch_restaurant
  before_action :fetch_address

  def edit; end

  def update
    if @address.update(address_params)
      return redirect_to restaurant_path(@restaurant), notice: 'Endereço atualizado com sucesso'
    end

    flash.now[:alert] = 'Não foi possível atualizar seu Endereço'
    render :edit, status: :unprocessable_entity
  end

  private

  def fetch_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def fetch_address
    @address = fetch_restaurant.address
    owner = current_restaurant_owner
    @restaurant = fetch_restaurant
    if @restaurant.restaurant_owner != owner
      return redirect_to Restaurant.find_by(restaurant_owner: owner), alert: 'Acesso negado - Não é permito visualizar dados de outro Restaurante'
    end
  end

  def address_params
    params.require(:address).permit(:street, :number, :district, :city, :state, :zip_code, :complement)
  end
end