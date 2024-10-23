class CreateRestaurants < ActiveRecord::Migration[7.2]
  def change
    create_table :restaurants do |t|
      t.string :brand_name
      t.string :corporate_name
      t.string :cnpj
      t.string :full_address
      t.string :phone
      t.string :email
      t.references :owner, null: false, foreign_key: true
      t.string :code

      t.timestamps
    end
  end
end
