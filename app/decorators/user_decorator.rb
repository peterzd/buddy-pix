class UserDecorator < Draper::Decorator

  def invited_for(card)
    (object.joined_albums.include? card) or (object.my_pending_invited_cards.include? card)
  end
end
