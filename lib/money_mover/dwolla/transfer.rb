module MoneyMover
  module Dwolla
    class Transfer < ApiResource
      attr_accessor :id, :funding_source_resource_location, :funding_destination_resource_location, :amount, :metadata

      validates_presence_of :funding_source_resource_location, :funding_destination_resource_location, :amount

      private

      def endpoint
        "transfers"
      end

      def request_params
        {
          _links: {
            destination: {
              href: funding_source_resource_location
            },
            source: {
              href: funding_destination_resource_location
            }
          },
          amount: {
            value: amount.to_s,
            currency: "USD"
          },
          metadata: metadata
        }
      end
    end
  end
end
