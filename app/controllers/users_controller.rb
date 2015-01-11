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

  def my_wall
    @user = current_user
    @photos = current_user.my_wall_pics
  end

  def my_wall_next_batch
    page = params[:page].to_i - 1
    @photos = PhotosQuery.user_wall_pics(current_user, page * PhotosQuery::NUMBER_FACTOR)
    if @photos.empty?
      render nothing: true, status: 404
    else
      render partial: "albums/photo", collection: @photos, locals: { from: "my_wall" }
    end
  end

  def alerts
    @invitations = current_user.my_pending_invitations + current_user.my_rejected_invitations
    @notifications = current_user.unread_notifications
  end

  def update_account_settings
    @messages = Hash.new
    @messages[:success] = Hash.new
    if params[:commit] == "Delete Account"
      user = current_user
      sign_out_and_redirect current_user
      UsersService.new(user).destroy_account
    else
      user = User.find params[:id]
      # set attributes, check if the attributes are changed
      user.first_name = user_params[:first_name]
      user.last_name = user_params[:last_name]
      user.email = user_params[:email]
      user.phone_number = user_params[:phone_number]
      if user.changed_attributes.any?
        user.save
        @messages[:success].merge!({ profile: "profile updated" })
      end

      if user_params[:profile_cover]
        UsersService.new(user).update_profile_cover(user_params, :profile_cover)
        @messages[:success].merge!({ profile_cover: "profile cover updated " })
      end

      if user_params[:cover_photo]
        UsersService.new(user).update_cover_photo(user_params, :cover_photo)
        @messages[:success].merge!({ cover_photo: "cover photo updated " })
      end

      current_pwd = params[:current_password]
      new_pwd = params[:new_password]
      confirm_pwd = params[:confirm_password]

      if current_pwd.present? && new_pwd.present? && confirm_pwd.present?
        if process_password(current_pwd, new_pwd, confirm_pwd)
          @messages[:success].merge!({ password: "password updated" })
        else
          flash[:danger] = "can not update password"
        end
      end

      flash[:hash] = @messages
      redirect_to dashboard_account_settings_path
    end
  end

  private
  def user_params
    params.require(:user).permit(:id, :first_name, :last_name, :email, { profile_cover: [:picture] }, { cover_photo: [:picture] }, :phone_number)
  end

  def process_password(current_pwd, new_pwd, confirm_pwd)
    return false unless current_user.valid_password? current_pwd
    return false if new_pwd != confirm_pwd
    user_id = current_user.id
    current_user.update password: new_pwd
    sign_in User.find(user_id), bypass: true
  end
end
