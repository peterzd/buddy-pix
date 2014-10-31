class Like < ActiveRecord::Base
  MOOD = { happy: "happy", like: "like", cool: "cool", sad: "sad", cheer_up: "cheer up" }

  belongs_to :liker, class_name: "User", foreign_key: :liker_id
  belongs_to :likeable, class_name: "Photo", foreign_key: :likeable_id
end
