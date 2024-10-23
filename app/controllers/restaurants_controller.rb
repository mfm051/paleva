class RestaurantsController < ApplicationController
  before_action :authenticate_owner!

  def show
    if current_owner.restaurant.present?
    else
      flash.now[:notice] = 'Para continuar, registre seu estabelecimento'
      render :new
    end
  end

  def new; end
end
