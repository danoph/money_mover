module MoneyMover
  module Dwolla
    class ApiClient
      def initialize(config = Config.new)
        @config = config
      end

      def post(url, request_params)
        RestClient.post build_url(url), request_params.to_json, request_headers
      end

      def get(url)
        RestClient.get build_url(url), request_headers
      end

      private

      def build_url(uri)
        [ @config.api_endpoint, uri ].join '/'
      end

      def request_headers
        {
          content_type: :json,
          accept: 'application/vnd.dwolla.v1.hal+json',
          Authorization: "Bearer #{@config.access_token}"
        }
      end
    end
  end
end
