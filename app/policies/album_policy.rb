class AlbumPolicy < ApplicationPolicy
  def index?
    user && user.persisted?
  end

  def new?
    user && user.persisted?
  end

  def create?
    user && user.persisted?
  end
end
