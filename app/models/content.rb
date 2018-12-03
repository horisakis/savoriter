class Content < ApplicationRecord
  has_many :favorites, dependent: :destroy
  scope :provider, ->(provider) { where(provider: provider) }
  scope :newer_by_source_id, ->(source_id) { where(source_id: source_id..Float::INFINITY) }
end
