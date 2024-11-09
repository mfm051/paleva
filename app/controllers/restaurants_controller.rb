class RestaurantsController < ApplicationController
  before_action :authenticate_owner!
  skip_before_action :get_restaurant_or_redirect!, only: [:new, :create]
  before_action :verify_owner_has_restaurant, only: [:new, :create]

  def overview; end

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

  private

  def verify_owner_has_restaurant
    if current_owner.restaurant
      return redirect_to current_owner.restaurant
    end
  end
end
