class FinancialReport < ApplicationRecord
  belongs_to :user
  validates :date, presence: true
  validates :cost, presence: true
  validates :revenue, presence: true
  validates :net_income, presence: true

  scope :newest, -> {order(created_at: :desc)}
end
