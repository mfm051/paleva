class CreateDrinks < ActiveRecord::Migration[7.2]
  def change
    create_table :drinks do |t|
      t.string :name
      t.string :description
      t.boolean :alcoholic
      t.integer :calories
      t.references :restaurant, null: false, foreign_key: true

      t.timestamps
    end
  end
end
