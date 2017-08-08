module MoneyMover
  module Dwolla
    class AccountFundingSource < ApiResource
      attr_accessor :status, :type, :name, :created

      def initialize(attrs)
        super id: attrs[:id], name: attrs[:name], status: attrs[:status], type: attrs[:type], created: attrs[:created], _links: attrs[:_links], _embedded: attrs[:_embedded]
      end

      def self.all(account_id)
        client = ApplicationClient.new

        response = client.get fetch_endpoint(account_id)
        response.body[:_embedded][:"funding-sources"].map {|source| new(source) }
      end

      def bank_account?
        type == 'bank'
      end

      private

      def self.fetch_endpoint(account_id)
        "/accounts/#{account_id}/funding-sources"
      end
    end
  end
end
