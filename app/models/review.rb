class Review < ApplicationRecord
  belongs_to :user
  belongs_to :tour
  has_many :comments, as: :commentable
  validates :title, presence: true, length: {maximum: Settings.max_name}
  validates :body, presence: true, length: {minimum: Settings.max_name,
    maximum: Settings.max_text}
  after_initialize :set_is_accepted
  acts_as_likeable

  def set_is_accepted
    self.is_accepted = false if self.new_record?
  end

  scope :accepted, -> {where(is_accepted: true)}
  scope :newest, -> {order(created_at: :desc)}
end
