module MoneyMover
  module Dwolla
    class FundingSource
      attr_reader :id, :resource_location

      def initialize(attrs)
        @customer_id = attrs[:customer_id]

        @id = nil
        @resource_location = nil

        @name = attrs[:name]
        @type = attrs[:type]
        @routing_number = attrs[:routing_number]
        @account_number = attrs[:account_number]
      end

      def save
        response = RestClient.post customer_funding_sources_endpoint, request_params.to_json, request_headers

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
          name: @name,
          type: @type,
          routingNumber: @routing_number,
          accountNumber: @account_number
        }
      end

      def customer_funding_sources_endpoint
        "https://api-uat.dwolla.com/customers/#{@customer_id}/funding-sources"
      end
    end
  end
end
