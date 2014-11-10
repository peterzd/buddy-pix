class BlogPolicy < ApplicationPolicy
  def index?
    user && user.admin?
  end

end
