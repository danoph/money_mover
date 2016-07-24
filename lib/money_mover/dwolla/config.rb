module MoneyMover
  module Dwolla
    class Config
      attr_reader :api_endpoint

      def initialize(attrs={})
        @api_endpoint = attrs[:api_endpoint] || "https://api-uat.dwolla.com"
      end
    end
  end
end
