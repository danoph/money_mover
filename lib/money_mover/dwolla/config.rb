module MoneyMover
  module Dwolla
    class Config
      attr_reader :access_token, :api_endpoint

      def initialize(attrs={})
        @access_token = attrs[:access_token] || 'X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak'
        @api_endpoint = attrs[:api_endpoint] || "https://api-uat.dwolla.com"
      end
    end
  end
end
