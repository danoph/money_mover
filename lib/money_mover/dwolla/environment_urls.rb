module MoneyMover
  module Dwolla
    class EnvironmentUrls
      ENVIRONMENTS = {
        :production => {
          :auth_url  => "https://www.dwolla.com/oauth/v2/authenticate",
          :token_url => "https://www.dwolla.com/oauth/v2/token",
          :api_url   => "https://api.dwolla.com"
        },
        :sandbox => {
          :auth_url  => "https://sandbox.dwolla.com/oauth/v2/authenticate",
          :token_url => "https://sandbox.dwolla.com/oauth/v2/token",
          :api_url   => "https://api-sandbox.dwolla.com"
        }
      }

      def initialize(ach_config = Config.new)
        @ach_config = ach_config
        @environment = @ach_config.environment
      end

      def api_url
        ENVIRONMENTS[@environment][:api_url]
      end

      def token_url
        ENVIRONMENTS[@environment][:token_url]
      end

      def auth_url
        ENVIRONMENTS[@environment][:auth_url]
      end
    end
  end
end
