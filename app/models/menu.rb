class Menu < ApplicationRecord
  belongs_to :restaurant
  has_many :menu_items
  has_many :dishes, through: :menu_items, source: :itemable, source_type: 'Dish'
  has_many :drinks, through: :menu_items, source: :itemable, source_type: 'Drink'

  validates :name, presence: true, uniqueness: { scope: :restaurant }
  validate :ensure_menu_has_item
  validate :ensure_dishes_belong_to_restaurant, if: :restaurant
  validate :ensure_drinks_belong_to_restaurant, if: :restaurant

  private

  def ensure_menu_has_item
    unless drinks.any? || dishes.any?
      errors.add :base, 'deve conter ao menos um item'
    end
  end

  def ensure_dishes_belong_to_restaurant
    unless dishes.all? { |dish| dish.restaurant == self.restaurant }
      errors.add :dish, 'deve pertencer ao restaurante do cardápio'
    end
  end

  def ensure_drinks_belong_to_restaurant
    unless drinks.all? { |drink| drink.restaurant == self.restaurant }
      errors.add :drink, 'deve pertencer ao restaurante do cardápio'
    end
  end
end
