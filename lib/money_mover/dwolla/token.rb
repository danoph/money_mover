module MoneyMover
  module Dwolla
    class Token
      attr_reader :account_id, :expires_in, :access_token, :refresh_token, :_links, :token_type, :refresh_expires_in, :scope

      def initialize(attrs={}, ach_config = Config.new, client = Client.new)
        @_links = attrs[:_links]
        @account_id = attrs[:account_id]
        @expires_in = attrs[:expires_in]
        @refresh_expires_in = attrs[:refresh_expires_in]
        @access_token = attrs[:access_token]
        @refresh_token = attrs[:refresh_token]
        @token_type = attrs[:token_type]
        @scope = attrs[:scope]

        @ach_config = ach_config
        @client = client
      end

      def request_new_token!
        response = @client.post @client.token_url, create_params
        Token.new response.body
      end
    end
  end
end
