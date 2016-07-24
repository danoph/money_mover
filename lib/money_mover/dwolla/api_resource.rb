module MoneyMover
  module Dwolla
    class ApiResource
      include ActiveModel::Model

      attr_reader :resource_location

      def save
        return false unless valid?

        response = ApiPostRequest.new url: endpoint, params: request_params, access_token: Dwolla.account_token_provider.access_token

        if response.success?
          @resource_location = response.resource_location
          @id = response.resource_id
        else
          add_errors response.errors
        end

        errors.empty?
      end

      def self.find(id)
        url = [ endpoint, id ].join '/'
        response = ApiGetRequest.new url: url, access_token: Dwolla.account_token_provider.access_token

        if response.success?
          new response.parsed_json
        else
          raise 'Record Not Found'
        end
      end

      private

      def add_errors(new_errors)
        new_errors.each_pair do |key, messages|
          messages.each {|message| errors.add key, message }
        end
      end
    end
  end
end
