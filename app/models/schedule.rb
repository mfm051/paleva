class Schedule < ApplicationRecord
  belongs_to :restaurant
  enum :weekday, [:sunday, :monday, :tuesday, :wednesday, :thursday, :friday, :saturday]

  validates :start_time, :end_time, :weekday, presence: true
  validates :end_time, comparison: { greater_than: :start_time, message: "deve ser posterior ao de abertura" }, if: :start_time
  validates :weekday, uniqueness: { scope: :restaurant, message: "já cadastrado para o restaurante",
                                    conditions: -> { where(active: true) } }
end
