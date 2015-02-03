class Blog < ActiveRecord::Base
  has_many :comments, as: :commentable, dependent: :destroy

  default_scope { order created_at: :desc }
end
