# use `skip_before_action` to solve the problem that user can not sign out, based on [this SO](http://stackoverflow.com/questions/20875591/actioncontrollerinvalidauthenticitytoken-in-registrationscontrollercreate_
class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:destroy]

  def new
    if params[:invitation_token]
      @invitation_token = params[:invitation_token]
    end
    super
  end

  def create
    self.resource = warden.authenticate!(auth_options)
    set_flash_message(:notice, :signed_in) if is_flashing_format?
    sign_in(resource_name, resource)

    if params[:invitation_token]
      token = params[:invitation_token]
      invitation_token = InvitationToken.find_by token: token
      action = invitation_token.action
      current_user.joins_album action
      redirect_to card_path action
    else
      yield resource if block_given?
      respond_with resource, location: after_sign_in_path_for(resource)
    end
  end
end
