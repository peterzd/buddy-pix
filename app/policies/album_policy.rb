class AlbumPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(hidden: [false, nil])
    end
  end

  def index?
    user && user.persisted?
  end

  def show?
    return true unless record.private?
    return false unless user
    user.admin? || (record.creator == user) || record.followers.include?(user)
  end

  def new?
    user && user.persisted?
  end

  def create?
    user && user.persisted?
  end

  def edit?
    update?
  end

  def update?
    user == record.creator
  end

  def hide_card?
    (record.creator == user) || user.admin?
  end

  def hidden_cards?
    user && user.persisted?
    # !(user.nil? || user.hidden_cards.empty?)
  end

  def unfollow?
    user && user.persisted?
  end

  def follow
    unfollow?
  end
end
