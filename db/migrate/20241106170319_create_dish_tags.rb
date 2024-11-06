class CreateDishTags < ActiveRecord::Migration[7.2]
  def change
    create_table :dish_tags do |t|
      t.string :description

      t.timestamps
    end
  end
end
