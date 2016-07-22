module MoneyMover
  module Dwolla
    class UnverifiedCustomer < Customer
      attr_reader :errors

      def save
        @errors = {}

        response = ApiPostRequest.new "customers", request_params

        if response.success?
          @resource_location = response.resource_location
          @id = response.resource_id
          true
        else
          @errors = response.errors
          false
        end
      end

      private

      def request_params
        {
          firstName: firstName,
          lastName: lastName,
          email: email,
          ipAddress: ipAddress
        }
      end
    end
  end
end
