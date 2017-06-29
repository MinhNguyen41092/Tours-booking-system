class User < ApplicationRecord
  mount_uploader :avatar, ImageUploader
  TEMP_EMAIL_PREFIX = "change@me"
  TEMP_EMAIL_REGEX = /\Achange@me/
  devise :database_authenticatable, :registerable, :omniauthable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable
  validates_format_of :email, without: TEMP_EMAIL_REGEX, on: :update
  attr_accessor :login
  has_one :identity
  has_one :cart
  has_one :identity, dependent: :destroy
  has_many :comments
  has_many :orders
  has_many :reviews
  has_many :financial_reports
  validates :username, presence: true, uniqueness: {case_sensitive: false}
  validate :validate_username

  class << self
    def find_for_database_authentication warden_conditions
      conditions = warden_conditions.dup
      if login = conditions.delete(:login)
        where(conditions.to_h).where(["lower(username) = :value OR lower(email) = :value",
          {:value => login.downcase}]).first
      elsif conditions.has_key?(:username) || conditions.has_key?(:email)
        where(conditions.to_h).first
      end
    end

    def find_for_oauth auth, signed_in_resource = nil
      identity = Identity.find_for_oauth auth

      user = signed_in_resource ? signed_in_resource : identity.user

      if user.nil?
        email_is_verified = auth.info.email && (auth.info.verified || auth.info.verified_email)
        email = auth.info.email if email_is_verified
        user = User.where(email: email).first if email

        if user.nil?
          user = User.new(
            username: auth.extra.raw_info.name,
            email: email ? email : "#{TEMP_EMAIL_PREFIX}-#{auth.uid}-#{auth.provider}.com",
            password: "password"
          )
          user.skip_confirmation!
          user.save
        end
      end

      if identity.user != user
        identity.user = user
        identity.save!
      end
      user
    end
  end

  def validate_username
    if User.where(email: username).exists?
      errors.add :username, :invalid
    end
  end

  def email_verified?
    self.email && self.email !~ TEMP_EMAIL_REGEX
  end
end
