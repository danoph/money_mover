module MoneyMover
  module Dwolla
    class UnverifiedCustomer
      include ActiveModel::Model

      attr_accessor :id, :firstName, :lastName, :email, :ipAddress

      attr_reader :resource_location

      validates_presence_of :firstName, :lastName, :email

      def save
        return false unless valid?

        response = ApiPostRequest.new "customers", request_params

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
          firstName: firstName,
          lastName: lastName,
          email: email,
          ipAddress: ipAddress
        }
      end
    end
  end
end
