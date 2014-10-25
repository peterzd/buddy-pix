class DashboardPolicy < Struct.new(:user, :dashboard)
  def account_settings?
    user && user.persisted?
  end
end
