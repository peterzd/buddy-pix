class ImageDecorator < Draper::Decorator

  class << self
    def cover_photo_img(user)
      user.cover_photo_url(:medium) || "dummy_img/cover_img.jpg"
    end
  end

end
