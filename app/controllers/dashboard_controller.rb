class DashboardController < ApplicationController
  respond_to :html, :json

  def account_settings
    @user = current_user
  end
end
