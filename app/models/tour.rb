class Tour < ApplicationRecord
  mount_uploader :image_url, ImageUploader
  has_many :reviews
  has_and_belongs_to_many :categories
  validates :name, :description, :price, :image_url,
    :duration, :location, presence: true
  validates :name, length: {minimum: Settings.min_tour_name,
    maximum: Settings.max_tour_name}
  validates :description, length: {minimum: Settings.min_tour_des,
    maximum: Settings.max_tour_des}
end
