# use `skip_before_action` to solve the problem that user can not sign out, based on [this SO](http://stackoverflow.com/questions/20875591/actioncontrollerinvalidauthenticitytoken-in-registrationscontrollercreate_
class Users::SessionsController < Devise::SessionsController
  skip_before_action :verify_authenticity_token, only: [:destroy]

end
