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
      attr_reader :errors

      def initialize(url, params, client = ApiClient.new)
        @url = url
        @params = params
        @client = client
        @errors = {}
      end

      def response
        @errors = {}

        begin
          @response ||= @client.post @url, @params
        rescue => e
          add_errors JSON.parse e.response.body, symbolize_names: true
          @response = e.response
        end
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

      private

      def add_errors(errors)
        if errors[:_embedded]
          errors[:_embedded][:errors].each do |error|
            if error[:path]
              key = error[:path].split('/')[1].to_sym
            else
              key = :base
            end

            add_error key, error[:message]
          end
        else
          add_error :base, erors[:message]
        end
      end

      def add_error(key, message)
        @errors[key] ||= []
        @errors[key] << message
      end
    end
  end
end
