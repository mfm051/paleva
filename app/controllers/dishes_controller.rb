class DishesController < ApplicationController
  before_action :build_dish, only: [:new, :create]
  def new; end

  def create
    params_dish = params.require(:dish).permit(:name, :description, :calories)
    @dish.attributes = params_dish
    if @dish.save
      redirect_to root_path, notice: 'Prato cadastrado com sucesso'
    end
  end

  private

  def build_dish
    restaurant = current_owner.restaurant
    @dish = restaurant.dishes.build
  end
end
