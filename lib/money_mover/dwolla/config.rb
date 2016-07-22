module MoneyMover
  module Dwolla
    class Config
      attr_reader :access_token, :api_server

      def initialize(attrs={})
        @access_token = attrs[:access_token] || 'X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak'
        @api_server = attrs[:api_server] || "https://api-uat.dwolla.com"
      end
    end
  end
end
