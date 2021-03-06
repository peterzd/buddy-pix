class AlbumDecorator < Draper::Decorator
  include Draper::LazyHelpers

  def hidden_link
    image_name = object.hidden? ? "view_" : ""
    path_name = object.hidden? ? "publish" : "hide"
    link_to image_tag("eye_#{image_name}icon.png") + "#{path_name.capitalize} Card", send("#{path_name}_card_card_path", object), method: :post, remote: true
  end

  def invite_btn_links
    return "" unless user_signed_in?
    if current_user == object.creator
      link_to "Invite user", new_card_invitation_path(object), class: "btn"
    elsif current_user.has_joined_album? object
      link_to "UnFollow", unfollow_card_path(object), class: "btn dull", remote: true
    else
      link_to "Follow", follow_card_path(object), class: "btn", remote: true
    end
  end

  def follow_btn_link(user)
    return "" if object.creator == user
    if user.has_joined_album? object
      link_to "UnFollow", unfollow_card_path(object), class: "btn dull", remote: true
    else
      link_to "Follow", follow_card_path(object), class: "btn", remote: true
    end

  end

  def private_text
    object.private? ? 'Private' : 'Public'
  end
end
