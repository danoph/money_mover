module MoneyMover
  module Dwolla
    class Config
      def initialize(config = MoneyMover::Dwolla.config_provider)
        @config = config
      end

      def webhook_secret_key
        @config.webhook_secret_key
      end

      def webhook_callback_url
        @config.webhook_callback_url
      end

      def api_key
        @config.api_key
      end

      def api_secret_key
        @config.api_secret_key
      end

      def environment
        @config.environment
      end

      def account_token_provider
        @config.account_token_provider
      end
    end
  end
end
