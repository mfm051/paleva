class RestaurantsController < ApplicationController
  before_action :authenticate_owner!

  def show
    if current_owner.restaurant.present?
      @restaurant = current_owner.restaurant
    else
      redirect_to new_restaurant_path, alert: 'Para continuar, registre seu estabelecimento'
    end
  end

  def new
    @restaurant = current_owner.build_restaurant
  end

  def create
    restaurant_params = params.require(:restaurant).permit(:brand_name, :corporate_name, :cnpj, :full_address, :phone,
                                                          :email)
    @restaurant = current_owner.build_restaurant(restaurant_params)
    if @restaurant.save
      redirect_to root_path, notice: 'Restaurante cadastrado com sucesso'
    else
      flash.now[:notice] = 'Restaurante não cadastrado'
      render :new, status: :unprocessable_entity
    end
  end

  def search
    @restaurant = current_owner.restaurant
    @query = params[:query]

    @dishes = @restaurant.dishes.where("name LIKE :query OR description LIKE :query", query: "%#{@query}%")
    @drinks = @restaurant.drinks.where("name LIKE :query OR description LIKE :query", query: "%#{@query}%")
  end
end
