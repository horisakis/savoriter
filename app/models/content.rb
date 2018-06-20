class Content < ApplicationRecord
  has_many :favorites, dependent: :destroy
end
