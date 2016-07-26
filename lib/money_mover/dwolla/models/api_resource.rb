module MoneyMover
  module Dwolla
    class ApiResource
      include ActiveModel::Model

      attr_accessor :id, :_links, :_embedded

      attr_reader :resource_location

      def initialize(attrs = {}, client = AccountClient.new)
        @id = attrs[:id]
        @resource_location = attrs[:resource_location]
        @_links = attrs[:_links]
        @client = client

        super attrs
      end

      def self.fetch
        client = AccountClient.new

        response = client.get fetch_endpoint

        if response.success?
          new response.body
        else
          #raise 'Customer Not Found'
          #puts "error: #{response.body}"
        end
      end

      def save
        return false unless valid?

        response = @client.post create_endpoint, create_params

        if response.success?
          @resource_location = response.resource_location
          @id = response.resource_id
        else
          populate_errors_from_response(response)
        end

        errors.empty?
      end

      def destroy
        response = @client.delete resource_endpoint

        populate_errors_from_response(response) unless response.success?

        errors.empty?
      end

      private

      def populate_errors_from_response(response)
        response.errors.each {|key, message| errors.add key, message }
      end

      def resource_endpoint
        "#{create_endpoint}/#{id}"
      end

      def create_params
        {}
      end
    end
  end
end
