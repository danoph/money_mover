module MoneyMover
  module Dwolla
    class ReceiveOnlyCustomer < Customer
      private

      validates_presence_of :firstName, :lastName, :email

      def create_params
        {
          firstName: firstName,
          lastName: lastName,
          email: email,
          type: 'receive-only',
          ipAddress: ipAddress
        }
      end
    end
  end
end
