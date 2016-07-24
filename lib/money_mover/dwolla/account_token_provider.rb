module MoneyMover
  module Dwolla
    class AccountTokenProvider
      def initialize(provider)
        @provider = provider
      end

      def access_token
        @provider.access_token
      end

      def refresh_token
        @provider.refresh_token
      end
    end
  end
end
