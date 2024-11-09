class DrinksController < ApplicationController
  before_action :build_drink, only: [:new, :create]
  before_action :get_drink_by_id, only: [:show, :edit, :update, :destroy, :deactivate, :activate]
  before_action :authenticate_restaurant!, only: [:edit, :update]

  def show; end

  def new; end

  def create
    @drink.attributes = params_drink

    if @drink.save
      redirect_to @drink, notice: 'Bebida cadastrada com sucesso'
    else
      flash.now[:alert] = 'Bebida não cadastrada'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @drink.update(params_drink)
      redirect_to @drink, notice: 'Bebida atualizada com sucesso'
    else
      flash.now[:alert] = 'Bebida não atualizada'
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @drink.delete
    redirect_to root_path, notice: 'Bebida removida com sucesso'
  end

  def deactivate
    @drink.inactive!

    redirect_to @drink
  end

  def activate
    @drink.active!

    redirect_to @drink
  end

  private

  def params_drink = params.require(:drink).permit(:name, :description, :calories, :alcoholic, :illustration)

  def build_drink
    @drink = @restaurant.drinks.build
  end

  def get_drink_by_id
    @drink = Drink.find_by(id: params[:id])
  end

  def authenticate_restaurant!
    unless @drink.restaurant == @restaurant
      redirect_to @restaurant
    end
  end
end
