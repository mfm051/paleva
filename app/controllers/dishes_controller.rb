class DishesController < ApplicationController
  before_action :build_dish, only: [:new, :create]
  before_action :get_dish_by_id, only: [:edit, :update]

  def new; end

  def create
    @dish.attributes = params_dish

    if @dish.save
      redirect_to root_path, notice: 'Prato cadastrado com sucesso'
    else
      flash.now[:alert] = 'Prato não cadastrado'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @dish.update(params_dish)
      redirect_to edit_dish_path(@dish), notice: 'Prato atualizado com sucesso'
    end
  end

  private

  def build_dish
    restaurant = current_owner.restaurant
    @dish = restaurant.dishes.build
  end

  def get_dish_by_id
    @dish = Dish.find(params[:id])
  end

  def params_dish = params.require(:dish).permit(:name, :description, :calories)
end
