module MoneyMover
  module Dwolla
    class Config
      attr_reader :api_endpoint, :account_token_provider

      def initialize(attrs={})
        @api_endpoint = attrs[:api_endpoint] || "https://api-uat.dwolla.com"
        @account_token_provider = attrs[:account_token_provider]
      end
    end
  end
end
