class Users::RegistrationsController < Devise::RegistrationsController
  def create
    super
  end

  protected
  def sign_up(resource_name, resource)
    logger.info "customize sign up"
    sign_in(resource_name, resource)
    token = params[:invitation_token]

    if token
      action = get_token_action token
      current_user.joins_album action
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

  private
  def get_token_action(token)
    @invitation_token ||= InvitationToken.find_by token: token
    @action = @invitation_token.action
  end
end
