class ApplicationPolicy
  attr_reader :user, :record

  def initialize(user, record)
    @user = user
    @record = record
  end

  def index?
    false
  end

  def show?
    scope.where(:id => record.id).exists?
  end

  def create?
    only_admin
  end

  def new?
    create?
  end

  def update?
    only_admin
  end

  def edit?
    update?
  end

  def destroy?
    only_admin
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope
    end
  end

  private
  def only_admin
    user && (user.admin?) ## only for admin
  end
end

