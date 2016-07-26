module MoneyMover
  module Dwolla
    class ApplicationToken < Token
      def access_token
        new_token = request_new_token!
        new_token.access_token
      end

      ## NOTE: application does not have refresh token, hit API again to get new access token
      def refresh_token
        access_token
      end

      private

      def create_params
        {
          grant_type: :client_credentials,
          client_id: @ach_config.api_key,
          client_secret: @ach_config.api_secret_key
        }
      end
    end
  end
end
