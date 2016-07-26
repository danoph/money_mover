module MoneyMover
  module Dwolla
    class Transfer < ApiResource
      attr_accessor :sender_funding_source_token, :destination_funding_source_token, :transfer_amount, :metadata

      validates_presence_of :sender_funding_source_token, :destination_funding_source_token, :transfer_amount

      private

      def create_endpoint
        "/transfers"
      end

      def create_params
        {
          _links: {
            destination: {
              href: "#{@client.api_url}/funding-sources/#{@destination_funding_source_token}"
            },
            source: {
              href: "#{@client.api_url}/funding-sources/#{@sender_funding_source_token}"
            }
          },
          amount: {
            value: @transfer_amount.to_s,
            currency: "USD"
          },
          metadata: @metadata
        }
      end
    end
  end
end
