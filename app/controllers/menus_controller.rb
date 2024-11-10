class MenusController < ApplicationController
  before_action :build_menu, only: [:new, :create]
  before_action :find_menu_by_id, only: [:show, :edit, :update]
  before_action :build_items, only: [:new, :edit]

  def index
    @menus = @restaurant.menus
  end

  def show; end

  def new; end

  def create
    @menu.attributes = menu_params

    if @menu.save
      redirect_to @menu, notice: 'Cardápio cadastrado com sucesso'
    else
      flash.now[:alert] = 'Cardápio não cadastrado'
      build_items
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @menu.attributes = menu_params

    if @menu.save
      redirect_to @menu, notice: 'Cardápio atualizado com sucesso'
    else
      flash.now[:alert] = 'Cardápio não atualizado'
      build_items
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def menu_params = params.require(:menu).permit(:name, dish_ids: [], drink_ids: [])

  def build_menu
    @menu = @restaurant.menus.build
  end

  def find_menu_by_id
    @menu = Menu.find(params[:id])
  end

  def build_items
    @restaurant_dishes = @restaurant.dishes.active
    @restaurant_drinks = @restaurant.drinks.active
  end
end
