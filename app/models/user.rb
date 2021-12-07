require "validator/email_validator"

class User < ApplicationRecord
  # Token生成モジュール
  include TokenGenerateService

  # バリデーション直前
  before_validation :downcase_email


  # gem bcrypt
  has_secure_password
  # validates
  validates :name, presence: true,
  length: { maximum: 30, allow_blank: true }

  validates :email, presence: true,
  email: { allow_blank: true }

  VALID_PASSWORD_REGEX = /\A[\w\-]+\z/
  validates :password, presence: true,
  length: { minimum: 8 },
  format: {
    with: VALID_PASSWORD_REGEX,
    message: :invalid_password 	# 追加
  },
  allow_nil: true

  ## methods
  # class method  ###########################
  class << self
    # emailからアクティブなユーザーを返す
    def find_by_activated(email)
      find_by(email: email, activated: true)
    end
  end
  # class method end #########################

  # 自分以外の同じemailのアクティブなユーザーがいる場合にtrueを返す
  def email_activated?
    users = User.where.not(id: id)
    users.find_by_activated(email).present?
  end

  #リフレッシュトークンのJWT ID を記憶する
  def remember(jti)
    update!(refresh_jti: jti)
  end

  #リフレッシュトークンのJWT ID を削除する
  def forget
    update!(refresh_jti: nil)
  end


  private

  # email小文字化
  def downcase_email
    self.email.downcase! if email
  end
end
