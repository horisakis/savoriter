class Content < ApplicationRecord
  has_many :favorites, dependent: :destroy
  scope :provider, ->(provider) { where(provider: provider) }
end
