class ChangeActiveDefaultValue < ActiveRecord::Migration[7.2]
  def change
    remove_column :schedules, :active, :boolean
    add_column :schedules, :active, :boolean, default: true
  end
end
