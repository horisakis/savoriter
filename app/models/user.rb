class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :omniauthable, omniauth_providers: %i[google twitter]

  has_many :auths, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorite_contents, through: :favorites, source: :content
end
