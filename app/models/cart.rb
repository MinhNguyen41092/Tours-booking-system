class Cart < ApplicationRecord
  belongs_to :user
  has_many :line_items, as: :line_itemable
end
