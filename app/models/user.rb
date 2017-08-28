# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  attr_reader :password
  validates :username, uniqueness: true
  validates :password, length: { minimum: 6, allow_nil: true}
  validates :username, :password_digest, :session_token, presence: true
  after_initialize :ensure_session_token

  def self.find_by_credentials(options)
    user = User.find_by(username: options[:username])
    return user if user &&
        BCrypt::Password.new(user.password_digest).is_password?(options[:password])
    nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def ensure_session_token
    self.session_token ||= SecureRandom.urlsafe_base64
  end
end
