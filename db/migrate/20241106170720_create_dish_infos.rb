class CreateDishInfos < ActiveRecord::Migration[7.2]
  def change
    create_table :dish_infos do |t|
      t.references :dish, null: false, foreign_key: true
      t.references :dish_tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end
