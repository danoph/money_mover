module MoneyMover
  module Dwolla
    class ApplicationClient < Client
      def initialize
        super ApplicationToken.new.access_token
      end
    end
  end
end
