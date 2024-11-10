class MenusController < ApplicationController
  def index
    @menus = @restaurant.menus
  end

  def show
    @menu = Menu.find(params[:id])
  end

  def new
    @menu = @restaurant.menus.build
  end

  def create
    @menu = @restaurant.menus.build(menu_params)

    if @menu.save
      redirect_to @menu, notice: 'Cardápio registrado com sucesso'
    end
  end

  private

  def menu_params = params.require(:menu).permit(:name, dish_ids: [], drink_ids: [])
end
