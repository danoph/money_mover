module MoneyMover
  module Dwolla
    class ApiClient
      def initialize(config = Config.new)
        @config = config
      end

      def post(url, request_params, access_token = nil)
        RestClient.post build_url(url), request_params.to_json, request_headers(access_token)
      end

      def get(url, access_token =  nil)
        RestClient.get build_url(url), request_headers(access_token)
      end

      private

      def build_url(uri)
        [ @config.api_endpoint, uri ].join '/'
      end

      def request_headers(access_token = nil)
        headers = {
          content_type: :json,
          accept: 'application/vnd.dwolla.v1.hal+json'
        }

        headers[:Authorization] = "Bearer #{access_token}" if access_token

        headers
      end
    end
  end
end
