module MoneyMover
  module Dwolla
    class Customer
      def initialize(attrs)
        @attrs = attrs
      end

      def save
        true
      end
    end
  end
end
