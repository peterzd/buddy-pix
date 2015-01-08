class Admin::ApplicationController < ApplicationController
  before_action :authenticate_user

  protected
  def authenticate_user
    redirect_to root_path unless current_user.admin?
  end

end
