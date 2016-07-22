module MoneyMover
  module Dwolla
    class UnverifiedCustomer < Customer
      def save
        response = ApiPostRequest.new "customers", request_params

        if response.success?
          @resource_location = response.resource_location
          @id = response.resource_id
          true
        else
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
