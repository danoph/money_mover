module MoneyMover
  module Dwolla
    class VerifiedBusinessCustomer < Customer
      validates_presence_of :address1,
        :city,
        :state,
        :postalCode,
        :dateOfBirth,
        :ssn,
        :phone,
        :businessClassification,
        :businessType,
        :businessName,
        :ein

      validates_inclusion_of :businessType, in: COMPANY_TYPES

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
          type: 'business',
        }

        # hack to fix bug on dwolla's side with funding sources being removed if no dba is sent
        create_attrs[:doingBusinessAs] = businessName unless doingBusinessAs.present?
        create_attrs[:ipAddress] = ipAddress if ipAddress.present?

        create_attrs
      end
    end
  end
end
