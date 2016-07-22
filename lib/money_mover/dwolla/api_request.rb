module MoneyMover
  module Dwolla
    class ApiRequest
      def initialize(url, client = ApiClient.new)
        @url = url
        @client = client
      end

      def response
        @response ||= @client.get @url
      end

      def success?
        response.code == 200
      end

      def parsed_response
        @parsed_response ||= JSON.parse response.body, symbolize_names: true
      end
    end
  end
end
