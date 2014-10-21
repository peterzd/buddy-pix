class Comments < ActiveRecord::Base
  belongs_to :commenter
  belongs_to :commentable
end
