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

      def parsed_json
        @parsed_json ||= JSON.parse response.body, symbolize_names: true
      end
    end

    class ApiPostRequest
      def initialize(url, params, client = ApiClient.new)
        @url = url
        @params = params
        @client = client
      end

      def response
        @response ||= @client.post @url, @params
      end

      def success?
        response.code == 201
      end

      def parsed_json
        @parsed_json ||= JSON.parse response.body, symbolize_names: true
      end

      def resource_location
        @resource_location ||= response.headers[:location]
      end

      def resource_id
        @resource_id ||= resource_location.split('/').last
      end
    end
  end
end
