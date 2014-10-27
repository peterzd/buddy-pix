class AlbumPolicy < ApplicationPolicy
  def new?
    user && user.persisted?
  end

  def create?
    user && user.persisted?
  end
end
