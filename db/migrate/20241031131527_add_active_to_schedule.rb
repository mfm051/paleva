class AddActiveToSchedule < ActiveRecord::Migration[7.2]
  def change
    add_column :schedules, :active, :boolean, default: false
  end
end
