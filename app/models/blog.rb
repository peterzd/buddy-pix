# == Schema Information
#
# Table name: blogs
#
#  id         :integer          not null, primary key
#  content    :text
#  title      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class Blog < ActiveRecord::Base
  has_many :comments, as: :commentable, dependent: :destroy

  default_scope { order created_at: :desc }
end
