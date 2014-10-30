class AlbumPolicy < ApplicationPolicy
  class Scope < Scope
    def resolve
      scope.where(hidden: [false, nil])
    end
  end

  def index?
    user && user.persisted?
  end

  def new?
    user && user.persisted?
  end

  def create?
    user && user.persisted?
  end

  def hide_card?
    (record.creator == user) || user.admin?
  end
end
