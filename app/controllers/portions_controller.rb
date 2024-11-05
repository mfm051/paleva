class PortionsController < ApplicationController
  def new
    @dish = Dish.find(params[:dish_id])
    @portion = @dish.portions.build
  end

  def create
    @dish = Dish.find(params[:dish_id])
    @portion = @dish.portions.build(portion_params)

    if @portion.save
      redirect_to @dish, notice: 'Porção registrada com sucesso'
    else
      flash.now[:alert] = 'Porção não registrada'
      render :new
    end
  end

  private

  def portion_params
    params_formatted = params.require(:portion).permit(:description, :price)
    params_formatted[:price] = params_formatted[:price].to_i * 100

    params_formatted
  end
end
