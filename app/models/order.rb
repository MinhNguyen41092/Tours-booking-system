class Order < ApplicationRecord
  belongs_to :user
  has_one :payment
  has_many :line_items, as: :line_itemable, dependent: :destroy
  accepts_nested_attributes_for :line_items

  enum status: [:pending, :paid, :canceled]

  scope :newest, -> {order(created_at: :desc)}
  scope :sold, -> {where(status: :paid)}
end
