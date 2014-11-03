class PhotoPolicy < ApplicationPolicy
  def like?
    user && user.persisted?
  end

  def new?
    create?
  end

  def create?
    return false if user.nil?

    card = record.album
    card.creator == user || user.admin? || !card.private || user.joined_albums.include?(card)
  end
end
