class RestaurantsController < ApplicationController
  before_action :authenticate_owner!

  def show
    if current_owner.restaurant.present?
      @restaurant = current_owner.restaurant
    else
      @restaurant = current_owner.build_restaurant
      flash.now[:notice] = 'Para continuar, registre seu estabelecimento'
      render :new
    end
  end

  def new
    @restaurant = current_owner.build_restaurant
  end

  def create
    restaurant_params = params.require(:restaurant).permit(:brand_name, :corporate_name, :cnpj, :full_address, :phone,
                                                          :email)
    @restaurant = current_owner.build_restaurant(restaurant_params)
    @restaurant.save
    redirect_to root_path, notice: 'Restaurante cadastrado com sucesso'
  end
end
