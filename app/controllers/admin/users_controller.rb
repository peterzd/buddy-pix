class Admin::UsersController < Admin::ApplicationController
  respond_to :html

  def index
    @users = User.all.order(:id)
  end

  def new

  end

  def create

  end
end
