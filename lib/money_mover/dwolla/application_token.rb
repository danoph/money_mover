module MoneyMover
  module Dwolla
    class ApplicationToken < Token
      def access_token
        @ach_config.account_token_provider.access_token
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
