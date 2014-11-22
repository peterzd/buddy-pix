class PhotoDecorator < Draper::Decorator
  include Draper::LazyHelpers

  def remove_link
    return "" unless user_signed_in?
    if object.creator == current_user
      link_to "remove", card_photo_path(object.album, object), data: { confirm: "sure to remove this photo?" }, method: :delete, class: "btn inline min_btn dull"
    end
  end
end
