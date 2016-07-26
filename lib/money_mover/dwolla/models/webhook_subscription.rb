module MoneyMover
  module Dwolla
    class WebhookSubscription < ApiResource
      attr_accessor :url, :secret

      validates_presence_of :url, :secret

      def initialize(attrs = {}, client = ApplicationClient.new)
        super_attrs = { id: attrs[:id], url: attrs[:url], secret: attrs[:secret] }
        super super_attrs, client
      end

      def self.all
        response = ApplicationClient.new.get fetch_endpoint
        response.body[:_embedded][:'webhook-subscriptions'].map{|sub| self.new(sub) }
      end

      private

      def self.fetch_endpoint
        '/webhook-subscriptions'
      end

      def create_endpoint
        '/webhook-subscriptions'
      end

      def create_params
        {
          url: url,
          secret: secret
        }
      end
    end
  end
end
