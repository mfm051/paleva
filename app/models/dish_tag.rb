class DishTag < ApplicationRecord
  has_many :dish_infos

  before_validation :downcase_description, if: :description

  validates :description, presence: true, uniqueness: true

  private

  def downcase_description
    self.description.downcase!
  end
end
