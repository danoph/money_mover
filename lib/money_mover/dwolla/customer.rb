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
        client = ApiClient.new
        response = client.get [ "customers", id ].join '/'

        case response.code
        when 200
          parsed_json_response = JSON.parse response.body, symbolize_names: true
          new parsed_json_response
        else
          raise 'Customer not Found'
        end
      end
    end
  end
end
