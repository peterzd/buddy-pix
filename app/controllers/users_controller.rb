class UsersController < ApplicationController
  def index
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end

  def update_account_settings
    user = User.find params[:id]
    user.update user_params
    render nothing: true
  end

  private
  def permitted_params
    params.permit(:user, :current_password, :new_password, :confirm_password, :commit, :profile_cover, :id )
  end

  def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :email, :phone_number)
  end
end
