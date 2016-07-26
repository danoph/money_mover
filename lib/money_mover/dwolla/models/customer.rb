module MoneyMover
  module Dwolla
    class Customer < ApiResource

      attr_accessor :firstName,
        :lastName,
        :email,
        :address1,
        :address2,
        :city,
        :state,
        :postalCode,
        :dateOfBirth,
        :ssn,
        :phone,
        :businessClassification,
        :businessType,
        :businessName,
        :ein,
        :doingBusinessAs,
        :website,
        :type,
        :ipAddress,
        :status,
        :created

      validates_presence_of :type

      def self.find(id)
        client = AccountClient.new

        response = client.get fetch_endpoint(id)

        if response.success?
          new response.body
        else
          raise 'Customer Not Found'
          #puts "error: #{response.body}"
        end
      end

      private

      def self.fetch_endpoint(id)
        "/customers/#{id}"
      end

      def create_endpoint
        "/customers"
      end
    end
  end
end
