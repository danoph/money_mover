module MoneyMover
  module Dwolla
    class FundingSource < ApiResource
      attr_accessor :customer_id, :id, :name, :type, :routingNumber, :accountNumber

      validates_presence_of :name, :type, :routingNumber, :accountNumber
      validates_inclusion_of :type, in: [ 'checking', 'savings' ]

      private

      def request_params
        {
          name: name,
          type: type,
          routingNumber: routingNumber,
          accountNumber: accountNumber
        }
      end

      def endpoint
        [ "customers", customer_id, "funding-sources" ].join('/')
      end
    end
  end
end
