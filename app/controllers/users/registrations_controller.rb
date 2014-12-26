class Users::RegistrationsController < Devise::RegistrationsController
  def create
    # copied from devise source code, modify the failed save part
    build_resource(sign_up_params)

    resource_saved = resource.save
    yield resource if block_given?
    if resource_saved
      if resource.active_for_authentication?
        set_flash_message :notice, :signed_up if is_flashing_format?
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        flash[:success] = "Buddypix has been send you an activation mail on your register email id, please activate your account"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      clean_up_passwords resource
      @validatable = devise_mapping.validatable?
      if @validatable
        @minimum_password_length = resource_class.password_length.min
      end
      flash[:danger] = resource.errors.full_messages.first
      render "devise/registrations/new"
    end
  end

  protected
  def sign_up(resource_name, resource)
    sign_in(resource_name, resource)
    token = params[:invitation_token]

    if token
      action = get_token_action token
      current_user.joins_album action if action
      @invitation_token.expire
    end
  end

  def after_sign_up_path_for(resource)
    token = params[:invitation_token]
    if token
      action = get_token_action token
      card_path action
    else
      after_sign_in_path_for(resource)
    end
  end

  def after_inactive_sign_up_path_for(resource)
    new_user_session_path
  end
  

  private
  def get_token_action(token)
    @invitation_token ||= InvitationToken.find_by token: token
    @action = @invitation_token.action
  end
end
