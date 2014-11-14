module API
  module V1
    module Helper
      extend ActiveSupport::Concern

      included do
        version 'v1'
        format :json

        helpers do
          def warden
            env['warden']
          end

          def authenticated
            return true if warden.authenticated?
            params[:access_token] && @user = User.find_by_authentication_token(params[:access_token])
          end

          def current_user
            warden.user || @user
          end

          def authenticate!
            error!("401 Unauthorized", 401) unless authenticated
          end
        end
      end
    end
  end
end
