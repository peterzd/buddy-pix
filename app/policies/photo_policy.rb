class PhotoPolicy < ApplicationPolicy
  def like?
    user && user.persisted?
  end

  def new?
    create?
  end

  def create?
    return false if user.nil?
    record.album.creator == user || user.admin?
  end
end
