class Blog < ActiveRecord::Base
  has_many :comments, as: :commentable, dependent: :destroy
end
