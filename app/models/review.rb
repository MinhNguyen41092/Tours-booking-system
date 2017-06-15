class Review < ApplicationRecord
  belongs_to :user
  belongs_to :tour
  has_many :comments, as: :commentable
  validates :title, presence: true, length: {maximum: Settings.max_name}
  validates :body, presence: true, length: {minimum: Settings.max_name,
    maximum: Settings.max_text}
  after_initialize :set_is_accepted

  def set_is_accepted
    self.is_accepted ||= false
  end

  scope :accepted, -> {where(is_accepted: true)}
end
