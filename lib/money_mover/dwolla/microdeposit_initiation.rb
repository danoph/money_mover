module MoneyMover
  module Dwolla
    class MicrodepositInitiation < ApiResource
      attr_accessor :funding_source_id

      validates_presence_of :funding_source_id

      private

      def endpoint
        [ "funding-sources", funding_source_id, "micro-deposits" ].join '/'
      end

      def request_params
        {}
      end
    end
  end
end
