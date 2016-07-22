module MoneyMover
  module Dwolla
    class Customer
      attr_accessor :id, :firstName, :lastName, :email, :ipAddress

      attr_reader :resource_location

      def initialize(attrs)
        @id = attrs[:id]
        @resource_location = attrs.dig(:_links, :self, :href)

        @firstName = attrs[:firstName]
        @lastName = attrs[:lastName]
        @email = attrs[:email]
        @ipAddress = attrs[:ipAddress]
      end

      def self.find(id)
        response = ApiRequest.new [ "customers", id ].join '/'

        if response.success?
          new response.parsed_json
        else
          raise 'Customer Not Found'
        end
      end
    end
  end
end
