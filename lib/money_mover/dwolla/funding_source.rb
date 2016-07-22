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
        @routingNumber = attrs[:routingNumber]
        @accountNumber = attrs[:accountNumber]
      end

      def save
        response = ApiPostRequest.new customer_funding_sources_endpoint, request_params

        if response.success?
          @resource_location = response.resource_location
          @id = response.resource_id
          true
        else
          false
        end
      end

      private

      def request_params
        {
          name: @name,
          type: @type,
          routingNumber: @routingNumber,
          accountNumber: @accountNumber
        }
      end

      def customer_funding_sources_endpoint
        [ "customers", @customer_id, "funding-sources" ].join('/')
      end
    end
  end
end
