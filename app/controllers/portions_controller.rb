class PortionsController < ApplicationController
  before_action :find_portion_parent, only: [:new, :create]
  before_action :find_portion, only: [:edit, :update]

  def new
    @portion = @parent.portions.build
  end

  def create
    @portion = @parent.portions.build(portion_params)

    if @portion.save
      redirect_to @parent, notice: 'Porção cadastrada com sucesso'
    else
      flash.now[:alert] = 'Porção não cadastrada'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @portion.update(portion_params)
      redirect_to @portion.portionable, notice: 'Porção atualizada com sucesso'
    else
      flash.now[:alert] = 'Porção não atualizada'
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def portion_params
    params_formatted = params.require(:portion).permit(:description, :price)
    params_formatted[:price] = params_formatted[:price].to_i * 100

    params_formatted
  end

  def find_portion_parent
    return @parent = Dish.find(params[:dish_id]) if params[:dish_id]

    @parent = Drink.find(params[:drink_id])
  end

  def find_portion
    @portion = Portion.find(params[:id])
  end
end
