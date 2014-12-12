class Image < ActiveRecord::Base
  attr_accessor :image_data
  belongs_to :imageable, polymorphic: true

  before_validation :set_image
  has_one :covered_user, class_name: "User", foreign_key: :cover_image_id
  has_one :covered_album, class_name: "Album", foreign_key: :cover_image_id

  has_attached_file :picture, :styles => { :medium => "300x300>", :thumb => "100x100>" }
  do_not_validate_attachment_file_type :picture
  # validates_attachment_content_type :picture, :content_type => /\Aimage\/.*\Z/

  def to_json
    { thumb_url: "http://localhost:3000/#{self.picture.url(:thumb) }", id: self.id }
  end

  private
  def set_image
    # for client uploaded base64 image
    if self.image_data.present?
      StringIO.open(Base64.decode64(image_data)) do |data|
        data.class.class_eval { attr_accessor :original_filename, :content_type }
        data.original_filename = "#{DateTime.now.to_i}.png"
        data.content_type = "image/png"
        self.picture = data
      end
    end
  end
end

