class ImagePolicy < ApplicationPolicy
  def like?
    user && user.persisted?
  end
end
