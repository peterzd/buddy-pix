class ImageDecorator < Draper::Decorator

  class << self
    def cover_photo_img(user)
      user.cover_photo_url(:large)
    end
  end

end
