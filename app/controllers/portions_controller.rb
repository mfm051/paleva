class PortionsController < ApplicationController
  def new
    @dish = Dish.find(params[:dish_id])
    @portion = @dish.portions.build
  end

  def create
    @dish = Dish.find(params[:dish_id])
    @portion = @dish.portions.build(params.require(:portion).permit(:description))
    @portion.price = params.require(:portion).permit(:price)[:price].to_i * 100

    @portion.save!
    redirect_to @dish
  end
end
