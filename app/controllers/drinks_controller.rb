class DrinksController < ApplicationController
  before_action :build_drink, only: [:new, :create]
  before_action :get_drink_by_id, only: [:edit, :update, :destroy]

  def new; end

  def create
    @drink.attributes = params_drink

    if @drink.save
      redirect_to root_path, notice: 'Bebida cadastrada com sucesso'
    else
      flash.now[:alert] = 'Bebida não cadastrada'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @drink.update(params_drink)
      redirect_to root_path, notice: 'Bebida atualizada com sucesso'
    else
      flash.now[:alert] = 'Bebida não atualizada'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @drink.delete
    redirect_to root_path, notice: 'Bebida removida com sucesso'
  end

  private

  def build_drink
    restaurant = current_owner.restaurant
    @drink = restaurant.drinks.build
  end

  def get_drink_by_id
    @drink = Drink.find(params[:id])
  end

  def params_drink = params.require(:drink).permit(:name, :description, :calories, :alcoholic)
end
