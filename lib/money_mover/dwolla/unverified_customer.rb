module MoneyMover
  module Dwolla
    class UnverifiedCustomer < ApiResource
      attr_accessor :id, :firstName, :lastName, :email, :ipAddress

      validates_presence_of :firstName, :lastName, :email

      private

      def endpoint
        "customers"
      end

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
