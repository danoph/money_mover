module MoneyMover
  module Dwolla
    class UnverifiedCustomer < Customer
      def save
        response = @client.post customers_endpoint, request_params

        case response.code
        when 201
          @resource_location = response.headers[:location]
          @id = @resource_location.split('/').last
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
