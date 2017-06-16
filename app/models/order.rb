class Order < ApplicationRecord
  belongs_to :user
  has_one :payment
  has_many :line_items, as: :line_itemable
end
