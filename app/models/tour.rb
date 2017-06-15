class Tour < ApplicationRecord
  mount_uploader :image_url, ImageUploader
  has_many :reviews
  has_and_belongs_to_many :categories
  validates :name, :description, :price, :image_url,
    :duration, :location, presence: true

  scope :newest, -> {order(created_at: :desc)}
end
