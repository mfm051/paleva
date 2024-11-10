class CreateMenuItems < ActiveRecord::Migration[7.2]
  def change
    create_table :menu_items do |t|
      t.references :menu, null: false, foreign_key: true
      t.belongs_to :itemable, polymorphic: true

      t.timestamps
    end
  end
end
