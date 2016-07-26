module MoneyMover
  module Dwolla
    class AccountToken < Token
      def access_token
        @ach_config.account_token_provider.access_token
      end

      def refresh_token
        @ach_config.account_token_provider.refresh_token
      end

      private

      def create_params
        {
          grant_type: :refresh_token,
          client_id: @ach_config.api_key,
          client_secret: @ach_config.api_secret_key,
          refresh_token: refresh_token
        }
      end
    end
  end
end
