class AlbumPolicy < ApplicationPolicy
  def new?
    user && user.persisted?
  end

  def create?
  end
end
