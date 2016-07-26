module MoneyMover
  module Dwolla
    class ApiServerResponse
      attr_reader :response

      def initialize(response)
        @response = response
      end

      def body
        HashWithIndifferentAccess.new @response.body
      end

      def errors
        @errors ||= ErrorHandler.new(body).errors
      end

      def success?
        @response.status >= 200 && @response.status < 400
      end

      def resource_location
        @response.headers[:location] if @response.headers[:location]
      end

      def resource_id
        resource_location.split('/').last rescue nil
      end
    end
  end
end
