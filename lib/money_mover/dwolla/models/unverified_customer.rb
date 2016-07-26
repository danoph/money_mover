module MoneyMover
  module Dwolla
    class UnverifiedCustomer < Customer
      private

      validates_presence_of :firstName, :lastName, :email

      def initialize(attrs={})
        super attrs.merge(type: 'unverified')
      end

      def create_params
        create_attrs = {
          firstName: firstName,
          lastName: lastName,
          email: email
        }

        create_attrs[:businessName] = businessName if businessName.present?
        create_attrs[:ipAddress] = ipAddress if ipAddress.present?
        #create_attrs[:type] = 'unverified'

        create_attrs
      end
    end
  end
end
