class AlbumDecorator < Draper::Decorator
  include Draper::LazyHelpers

  def hidden_link
    image_name = object.hidden? ? "view_" : ""
    path_name = object.hidden? ? "view" : "hide"
    link_to image_tag("eye_#{image_name}icon.png") + "#{path_name.capitalize} Card", send("#{path_name}_card_card_path", object), method: :post, remote: true
  end
end
