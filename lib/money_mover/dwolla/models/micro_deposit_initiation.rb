module MoneyMover
  module Dwolla
    class MicroDepositInitiation < ApiResource
      attr_accessor :funding_source_id

      validates_presence_of :funding_source_id

      private

      def create_endpoint
        "/funding-sources/#{funding_source_id}/micro-deposits"
      end

      def create_params
        {}
      end
    end
  end
end
