module MoneyMover
  module Dwolla
    class Customer < ApiResource
      attr_accessor :id, :firstName, :lastName, :email, :ipAddress, :type, :status

      def initialize(attrs={})
        @attrs = attrs
        @resource_location = attrs.dig(:_links, :self, :href)

        super id: attrs[:id],
          firstName: attrs[:firstName],
          lastName: attrs[:lastName],
          email: attrs[:email],
          ipAddress: attrs[:ipAddress],
          type: attrs[:type],
          status: attrs[:status]
      end

      def self.find(id)
        response = ApiGetRequest.new [ endpoint, id ].join '/'

        if response.success?
          new response.parsed_json
        else
          raise 'Customer Not Found'
        end
      end

      private

      def self.endpoint
        "customers"
      end
    end
  end
end
