class Comment < ActiveRecord::Base
  belongs_to :commenter, class_name: "User", foreign_key: :commenter_id
  # belongs_to :commentable, class_name: "Photo", foreign_key: :commentable_id
  belongs_to :commentable, polymorphic: true

  has_one :image, as: :imageable, dependent: :destroy

  has_many :replies, class_name: "Comment", as: :commentable

  validates :content, presence: true

  class << self
    def total_comments_per_day(date)
      comments = []
      all.each do |comment|
        comments << comment if comment.created_at.to_date == date
      end
      comments
    end
  end

  def picture_url(format=:large)
    return "" if image.nil?
    image.picture.url format
  end

end

