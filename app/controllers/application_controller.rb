class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :restaurant_active

  protected

  def restaurant_active
    current_path_is_valid = (request.path != new_restaurant_path) && (request.path != destroy_restaurant_owner_session_path)

    if restaurant_owner_signed_in? && current_path_is_valid && current_restaurant_owner&.restaurant.nil?
      redirect_to new_restaurant_path, alert: 'Por favor, conclua seu cadastro'
    end
  end

  def fetch_restaurant_owner
    @owner = current_restaurant_owner
  end
end
