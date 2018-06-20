class Favorite < ApplicationRecord
  belongs_to :user_id
  belongs_to :content_id
end
