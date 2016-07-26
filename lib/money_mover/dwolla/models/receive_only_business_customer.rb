module MoneyMover
  module Dwolla
    class ReceiveOnlyBusinessCustomer < Customer
      def initialize(attrs = {})
        attrs[:type] = 'receive-only'
        super attrs
      end
      private

      validates_presence_of :firstName, :lastName, :email

      def create_params
        create_attrs = {
          firstName: firstName,
          lastName: lastName,
          email: email,
        }

        create_attrs[:businessName] = businessName if businessName.present?
        create_attrs[:ipAddress] = ipAddress if ipAddress.present?
        create_attrs[:type] = type

        create_attrs
      end
    end
  end
end
