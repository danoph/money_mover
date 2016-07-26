module MoneyMover
  module Dwolla
    class RootAccount < ApiResource
      def account_resource_id
        account_resource_location.split('/').last
      end

      def account_resource_location
        _links.dig :account, :href
      end

      def funding_sources
        @funding_sources ||= AccountFundingSource.all(account_resource_id)
      end

      def bank_account_funding_source
        funding_sources.detect{|source| source.bank_account? }
      end

      private

      def self.fetch_endpoint
        "/"
      end
    end
  end
end
