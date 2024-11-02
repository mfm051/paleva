class RestaurantsController < ApplicationController
  before_action :authenticate_owner!
  before_action :get_restaurant, only: [:show]

  def show
    @schedules = @restaurant.schedules.where(active: true)
  end

  def new
    @restaurant = current_owner.build_restaurant
  end

  def create
    restaurant_params = params.require(:restaurant).permit(:brand_name, :corporate_name, :cnpj, :full_address, :phone,
                                                          :email)
    @restaurant = current_owner.build_restaurant(restaurant_params)
    if @restaurant.save
      redirect_to restaurant_path, notice: 'Restaurante cadastrado com sucesso'
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
