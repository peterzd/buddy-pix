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
    user.update user_params.except(:profile_cover, :cover_photo)

    if user_params[:profile_cover]
      image = Image.create user_params[:profile_cover]
      user.set_profile_cover image
    end

    if user_params[:cover_photo]
      image = Image.create user_params[:cover_photo]
      user.set_cover_photo image
    end
    # render nothing: true
    redirect_to dashboard_account_settings_path
  end

  private
  def permitted_params
    params.permit(:user, :current_password, :new_password, :confirm_password, :commit, :profile_cover, :id )
  end

  def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :email, { profile_cover: [:picture] }, { cover_photo: [:picture] }, :phone_number)
  end
end
