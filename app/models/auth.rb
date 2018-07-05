class Auth < ApplicationRecord
  validates :user_id,      presence: true
  validates :uid,          presence: true
  validates :provider,     presence: true
  validates :token,        presence: true
  validates :secret_token, presence: true
  validates :destination,  inclusion: { in: [true, false] }

  belongs_to :user

  def self.find_by_omniauth(auth)
    find_by(provider: auth[:provider], uid: auth[:uid])
  end

  def self.create_from_omniauth(user_id, auth)
    case auth[:provider]
    when 'google'
      create(user_id: user_id,
             provider: auth[:provider],
             uid: auth[:uid],
             token: auth[:credentials][:token],
             secret_token: auth[:credentials][:refresh_token],
             expires_at: auth[:credentials][:expires_at],
             save_path: 'savoriter/media')

    when 'twitter'
      create(user_id: user_id,
             provider: auth[:provider],
             uid: auth[:uid],
             token: auth[:credentials][:token],
             secret_token: auth[:credentials][:secret])
    else
      logger.error("Unknown providr:#{auth[:provider]} user_id:#{user_id}")
      nil
    end
  end

  def self.where_medias(user_id)
    Auth.where(user_id: user_id).where.not(provider: 'google')
  end

  def self.find_strage(user_id)
    Auth.where(user_id: user_id, destination: true)[0]
  end
end
