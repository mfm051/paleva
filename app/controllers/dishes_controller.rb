class DishesController < ApplicationController
  before_action :build_dish, only: [:new, :create]
  before_action :get_dish_by_id, only: [:show, :edit, :update, :deactivate, :activate]
  before_action :authenticate_restaurant!, only: [:edit, :update, :deactivate, :activate]

  def show; end

  def new
    5.times { @dish.dish_tags.build }
  end

  def create
    @dish.attributes = params_dish

    if @dish.save
      redirect_to @dish, notice: 'Prato cadastrado com sucesso'
    else
      flash.now[:alert] = 'Prato não cadastrado'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @dish.update(params_dish)
      redirect_to @dish, notice: 'Prato atualizado com sucesso'
    else
      flash.now[:alert] = 'Prato não atualizado'
      render :edit, status: :unprocessable_entity
    end
  end

  def deactivate
    @dish.inactive!

    redirect_to dish_path(@dish)
  end

  def activate
    @dish.active!

    redirect_to dish_path(@dish)
  end

  private

  def build_dish
    restaurant = current_owner.restaurant
    @dish = restaurant.dishes.build
  end

  def get_dish_by_id
    @dish = Dish.find(params[:id])
  end

  def params_dish = params.require(:dish).permit(:name, :description, :calories, :illustration,
                                                  dish_tags_attributes: [:description])

  def authenticate_restaurant!
    unless @dish.restaurant == @restaurant
      redirect_to @restaurant
    end
  end
end
