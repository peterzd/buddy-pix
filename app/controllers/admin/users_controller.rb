class Admin::UsersController < Admin::ApplicationController
  respond_to :html
  before_action :set_user, only: [:destroy]

  def index
    @users = User.all.order(:id)
  end

  def new

  end

  def create

  end

  def destroy
    @user.destroy
    redirect_to admin_users_path
  end

  private
  def set_user
    @user = User.find params[:id]
  end
end
