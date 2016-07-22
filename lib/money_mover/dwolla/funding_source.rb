module MoneyMover
  module Dwolla
    class FundingSource
      include ActiveModel::Model

      attr_accessor :customer_id, :id, :name, :type, :routingNumber, :accountNumber

      attr_reader :resource_location

      validates_presence_of :name, :type, :routingNumber, :accountNumber

      validates_inclusion_of :type, in: [ 'checking', 'savings' ]

      def save
        return false unless valid?

        response = ApiPostRequest.new customer_funding_sources_endpoint, request_params

        if response.success?
          @resource_location = response.resource_location
          @id = response.resource_id
        else
          add_errors response.errors
        end

        errors.empty?
      end

      private

      def add_errors(new_errors)
        new_errors.each_pair do |key, messages|
          messages.each {|message| errors.add key, message }
        end
      end

      def request_params
        {
          name: name,
          type: type,
          routingNumber: routingNumber,
          accountNumber: accountNumber
        }
      end

      def customer_funding_sources_endpoint
        [ "customers", customer_id, "funding-sources" ].join('/')
      end
    end
  end
end
