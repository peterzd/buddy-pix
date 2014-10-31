class PhotoPolicy < ApplicationPolicy
  def like?
    user && user.persisted?
  end
end
