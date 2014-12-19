class CustomFailure < Devise::FailureApp
    def redirect_url
      #return super unless [:worker, :employer, :user].include?(scope) #make it specific to a scope
      user = User.find_by email: params[:user][:email]
      if user and (user.confirmed_at.nil?)
        flash[:danger] = "Please confirm your account in your email first"
      else
        flash[:danger] = "email or password error"
      end
      new_user_session_path
    end

    # You need to override respond to eliminate recall
    def respond
      if http_auth?
        http_auth
      else
        redirect
      end
    end
  end
