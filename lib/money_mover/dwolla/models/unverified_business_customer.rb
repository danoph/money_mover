module MoneyMover
  module Dwolla
    class UnverifiedBusinessCustomer < Customer
      validates_presence_of :businessName

      def initialize(attrs = {})
        attrs[:type] = 'unverified'
        super attrs
      end

      private

      def create_params
        create_attrs = {
          firstName: firstName,
          lastName: lastName,
          email: email,
          address1: address1,
          address2: address2,
          city: city,
          state: state,
          postalCode: postalCode,
          dateOfBirth: dateOfBirth,
          ssn: ssn,
          phone: phone,
          businessClassification: businessClassification,
          businessType: businessType,
          businessName: businessName,
          ein: ein,
          doingBusinessAs: doingBusinessAs,
          website: website,
          type: type,
          ipAddress: ipAddress
        }

        # hack to fix bug on dwolla's side with funding sources being removed if no dba is sent
        create_attrs[:doingBusinessAs] = businessName unless doingBusinessAs.present?

        create_attrs.compact
      end
    end
  end
end
