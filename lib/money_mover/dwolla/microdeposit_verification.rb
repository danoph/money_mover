module MoneyMover
  module Dwolla
    class MicrodepositVerification < ApiResource
      attr_accessor :funding_source_id, :amount1, :amount2

      validates_presence_of :funding_source_id, :amount1, :amount2

      validates_numericality_of :amount1, less_than_or_equal_to: 0.10, greater_than: 0
      validates_numericality_of :amount2, less_than_or_equal_to: 0.10, greater_than: 0

      private

      def endpoint
        [ "funding-sources", funding_source_id, "micro-deposits" ].join '/'
      end

      def request_params
        {
          amount1: {
            value: amount1,
            currency: "USD"
          },
          amount2: {
            value: amount2,
            currency: "USD"
          }
        }
      end
    end
  end
end
