module MoneyMover
  module Dwolla
    class Customer
      attr_accessor :id, :firstName, :lastName, :email, :ipAddress

      attr_reader :resource_location

      def initialize(attrs, client = ApiClient.new)
        @client = client

        @id = attrs[:id]
        @resource_location = attrs.dig(:_links, :self, :href)

        @firstName = attrs[:firstName]
        @lastName = attrs[:lastName]
        @email = attrs[:email]
        @ipAddress = attrs[:ipAddress]
      end

      def self.find(id)
        request = ApiRequest.new [ "customers", id ].join '/'

        if request.success?
          new request.parsed_response
        else
          raise 'Customer Not Found'
        end
      end
    end
  end
end
