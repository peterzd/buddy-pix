class Comment < ActiveRecord::Base
  belongs_to :commenter, class_name: "User", foreign_key: :commenter_id
  belongs_to :commentable, class_name: "Image", foreign_key: :commentable_id
end
