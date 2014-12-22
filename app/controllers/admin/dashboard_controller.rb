class Admin::DashboardController < Admin::ApplicationController
  def index
    @inactive_users = User.inactive_users
  end
end
