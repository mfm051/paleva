class Portion < ApplicationRecord
  belongs_to :portionable, polymorphic: true

  validates :description, :price, presence: true
  validates :price, numericality: { only_integer: true, greater_than: 0 }
end
