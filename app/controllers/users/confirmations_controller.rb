class Users::ConfirmationsController < Devise::ConfirmationsController

  # copied from devise source code
  def show
    self.resource = resource_class.confirm_by_token(params[:confirmation_token])
    yield resource if block_given?

    if resource.errors.empty?
      flash[:success] = "Your account has been activated"
      respond_with_navigational(resource){ redirect_to after_confirmation_path_for(resource_name, resource) }
    else
      respond_with_navigational(resource.errors, status: :unprocessable_entity){ render :new }
    end
  end
  
end
