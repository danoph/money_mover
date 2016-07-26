module MoneyMover
  module Dwolla
    class FundingSource < ApiResource
      attr_accessor :name, :type, :routingNumber, :accountNumber

      validates_presence_of :name, :type, :routingNumber, :accountNumber
      validates_inclusion_of :type, :in => %w( checking savings )

      def initialize(customer_id, attrs={})
        @customer_id = customer_id
        super attrs
      end

      private

      def create_endpoint
        "/customers/#{@customer_id}/funding-sources"
      end

      def create_params
        {
          name: name,
          type: type,
          routingNumber: routingNumber,
          accountNumber: accountNumber
        }
      end
    end
  end
end
