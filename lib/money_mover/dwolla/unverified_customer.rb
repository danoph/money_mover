module MoneyMover
  module Dwolla
    class UnverifiedCustomer
      attr_reader :id, :resource_location

      def initialize(attrs)
        @id = nil
        @resource_location = nil

        @first_name = attrs[:first_name]
        @last_name = attrs[:last_name]
        @email = attrs[:email]
        @ip_address = attrs[:ip_address]
      end

      def save
        response = RestClient.post customers_endpoint, request_params.to_json, request_headers

        case response.code
        when 201
          @resource_location = response.headers[:location]
          @id = @resource_location.split('/').last
          true
        else
          false
        end
      end

      private

      def access_token
        'X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak'
      end

      def request_headers
        {
          content_type: :json,
          accept: 'application/vnd.dwolla.v1.hal+json',
          Authorization: "Bearer #{access_token}"
        }
      end

      def request_params
        {
          firstName: @first_name,
          lastName: @last_name,
          email: @email,
          ipAddress: @ip_address
        }
      end

      def customers_endpoint
        "https://api-uat.dwolla.com/customers"
      end
    end
  end
end
