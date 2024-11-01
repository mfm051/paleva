class CreateSchedules < ActiveRecord::Migration[7.2]
  def change
    create_table :schedules do |t|
      t.integer :weekday
      t.time :start_time
      t.time :end_time
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
