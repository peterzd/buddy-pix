class Like < ActiveRecord::Base
  MOOD = { happy: 1, like: 2, cool: 3, sad: 4, cheer_up: 5 }

  belongs_to :liker, class_name: "User", foreign_key: :liker_id
  belongs_to :likeable, class_name: "Image", foreign_key: :likeable_id
end
