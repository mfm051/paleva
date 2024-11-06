class PortionsController < ApplicationController
  before_action :find_parent, only: [:new, :create]

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

  private

  def portion_params
    params_formatted = params.require(:portion).permit(:description, :price)
    params_formatted[:price] = params_formatted[:price].to_i * 100

    params_formatted
  end

  def find_parent
    return @parent = Dish.find(params[:dish_id]) if params[:dish_id]

    @parent = Drink.find(params[:drink_id])
  end
end
