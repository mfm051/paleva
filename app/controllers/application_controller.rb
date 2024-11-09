class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :configure_permitted_parameters, if: :devise_controller?

  before_action :authenticate_owner!
  before_action :get_restaurant_or_redirect!, if: :current_owner, unless: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:cpf, :name, :surname])
  end

  def get_restaurant_or_redirect!
    if current_owner.restaurant.present?
      @restaurant = current_owner.restaurant
    else
      return redirect_to new_restaurant_path, alert: 'Para continuar, registre seu estabelecimento'
    end
  end
end
