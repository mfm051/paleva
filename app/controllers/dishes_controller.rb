class DishesController < ApplicationController
  before_action :build_dish, only: [:new, :create]
  before_action :get_dish_by_id, only: [:show, :edit, :update, :destroy, :deactivate, :activate]

  def show; end

  def new; end

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

  def destroy
    @dish.delete
    redirect_to root_path, notice: 'Prato removido com sucesso'
  end

  private

  def build_dish
    restaurant = current_owner.restaurant
    @dish = restaurant.dishes.build
  end

  def get_dish_by_id
    @dish = Dish.find(params[:id])
  end

  def params_dish = params.require(:dish).permit(:name, :description, :calories, :illustration)
end
