class Order < ApplicationRecord
  belongs_to :user
  has_one :payment
  has_many :line_items, as: :line_itemable, dependent: :destroy
  accepts_nested_attributes_for :line_items

  enum status: [:pending, :paid, :canceled]
end
