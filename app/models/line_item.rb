class LineItem < ApplicationRecord
  belongs_to :line_itemable, polymorphic: true
  belongs_to :tour
  validates :price, presence: true
  after_initialize :set_traveler, unless: :persisted?

  def set_traveler
    self.travelers ||= 1
  end
end
