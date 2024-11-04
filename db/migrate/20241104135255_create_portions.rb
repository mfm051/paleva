class CreatePortions < ActiveRecord::Migration[7.2]
  def change
    create_table :portions do |t|
      t.belongs_to :portionable, polymorphic: true
      t.string :description
      t.integer :price

      t.timestamps
    end
  end
end
