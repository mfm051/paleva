class SchedulesController < ApplicationController
  before_action :get_restaurant, only: [:new, :create]

  def new
    @schedule = @restaurant.schedules.build
    @weekdays_translated = Schedule.weekdays.keys.map { |day| [t(day), day] }
  end

  def create
    @schedule = @restaurant.schedules.build(schedule_params)
    @weekdays_translated = Schedule.weekdays.keys.map { |day| [t(day), day] }

    @schedule.save!
    redirect_to restaurant_path, notice: 'Horário registrado com sucesso'
  end

  private

  def schedule_params = params.require(:schedule).permit(:start_time, :end_time, :weekday)
end
