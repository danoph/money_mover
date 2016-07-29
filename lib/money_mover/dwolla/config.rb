module MoneyMover
  module Dwolla
    class Config
      def initialize(config_provider = MoneyMover::Dwolla.config_provider)
        @config_provider = config_provider
      end

      def webhook_secret_key
        @config_provider.webhook_secret_key
      end

      def webhook_callback_url
        @config_provider.webhook_callback_url
      end

      def api_key
        @config_provider.api_key
      end

      def api_secret_key
        @config_provider.api_secret_key
      end

      def environment
        @config_provider.environment
      end

      def account_token_provider
        @config_provider.account_token_provider.new
      end
    end
  end
end
