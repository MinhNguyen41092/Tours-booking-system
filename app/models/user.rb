class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable
  has_one :bank_account
  has_one :cart
  has_many :comments
  has_many :orders
  has_many :reviews
  has_many :financial_reports
end
