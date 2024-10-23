class RestaurantsController < ApplicationController
  before_action :authenticate_owner!

  def show; end

  def new; end
end
