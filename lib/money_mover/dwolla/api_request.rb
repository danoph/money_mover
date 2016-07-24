module MoneyMover
  module Dwolla
    class ApiRequest
      attr_reader :errors

      def initialize(opts={}, client = ApiClient.new)
        @url = opts[:url]
        @params = opts[:params]
        @access_token = opts[:access_token]
        @client = client
        @errors = {}
      end

      def success?
        response.code >= 200 && response.code < 400
      end

      def parsed_json
        @parsed_json ||= JSON.parse response.body, symbolize_names: true
      end

      private

      def response
        return @response if @response

        @errors = {}

        begin
          @response = perform_request
        rescue => e
          add_errors JSON.parse e.response.body, symbolize_names: true
          @response = e.response
        end

        @response
      end

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
          add_error :base, errors[:message]
        end
      end

      def add_error(key, message)
        @errors[key] ||= []
        @errors[key] << message
      end
    end

    class ApiGetRequest < ApiRequest
      def success?
        response.code == 200
      end

      private

      def perform_request
        @client.get @url, @access_token
      end
    end

    class ApiPostRequest < ApiRequest
      #def success?
        #response.code == 201
      #end

      def resource_location
        @resource_location ||= response.headers[:location] if response.headers[:location]
      end

      def resource_id
        @resource_id ||= resource_location.split('/').last if resource_location
      end

      private

      def perform_request
        @client.post @url, @params, @access_token
      end
    end
  end
end
