class RestaurantsController < ApplicationController
  before_action :authenticate_owner!, only: [:show]
  def show

  end
end
