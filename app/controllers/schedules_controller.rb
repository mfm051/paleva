class SchedulesController < ApplicationController
  before_action :get_restaurant, only: [:new, :create, :edit, :update]

  def new
    @schedule = @restaurant.schedules.build
  end

  def create
    @schedule = @restaurant.schedules.build(schedule_params)

    if @schedule.save
      redirect_to restaurant_path, notice: 'Horário registrado com sucesso'
    else
      flash.now[:alert] = 'Horário não registrado'
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @restaurant.update(restaurant_schedules_params)
      redirect_to restaurant_path, notice: 'Horários editados com sucesso'
    end
  end

  private

  def schedule_params = params.require(:schedule).permit(:start_time, :end_time, :weekday)

  def restaurant_schedules_params = params.require(:restaurant).permit(schedules_attributes: [:id, :active, :start_time, :end_time])
end
