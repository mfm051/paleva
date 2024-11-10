class MenusController < ApplicationController
  def index
    @menus = @restaurant.menus
  end

  def new
    @menu = @restaurant.menus.build
  end
end
