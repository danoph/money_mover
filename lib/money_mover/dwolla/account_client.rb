module MoneyMover
  module Dwolla
    class AccountClient < Client
      def initialize
        super AccountToken.new.access_token
      end
    end
  end
end
