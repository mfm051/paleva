class AddSurnameToOwner < ActiveRecord::Migration[7.2]
  def change
    add_column :owners, :surname, :string
  end
end
