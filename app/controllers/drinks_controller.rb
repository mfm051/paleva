class DrinksController < ApplicationController
  before_action :build_drink, only: [:new, :create]

  def new; end

  def create
    params_drinks = params.require(:drink).permit(:name, :description, :calories, :alcoholic)
    @drink.attributes = params_drinks

    if @drink.save
      redirect_to root_path, notice: 'Bebida cadastrada com sucesso'
    end
  end

  private

  def build_drink
    restaurant = current_owner.restaurant
    @drink = restaurant.drinks.build
  end
end
