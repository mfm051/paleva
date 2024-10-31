class HomeController < ApplicationController
  before_action :authenticate_owner!

  def index
    if current_owner.restaurant.present?
      @restaurant = current_owner.restaurant
    else
      redirect_to new_restaurant_path, alert: 'Para continuar, registre seu estabelecimento'
    end
  end
end
