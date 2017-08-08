module MoneyMover
  module Dwolla
    class Customer < ApiResource
      COMPANY_TYPES = %w( soleproprietorship llc partnership corporation )

      attr_accessor :firstName,
        :lastName,
        :email,
        :address1,
        :address2,
        :city,
        :state,
        :postalCode,
        :dateOfBirth,
        :ssn,
        :phone,
        :businessClassification,
        :businessType,
        :businessName,
        :ein,
        :doingBusinessAs,
        :website,
        :type,
        :ipAddress,
        :status,
        :created

      def self.find(id)
        client = ApplicationClient.new

        response = client.get fetch_endpoint(id)

        if response.success?
          new response.body
        else
          raise 'Customer Not Found'
          #puts "error: #{response.body}"
        end
      end

      def save
        return false unless valid?

        if @id
          response = @client.post self.class.fetch_endpoint(@id), create_params
          add_errors_from response unless response.success?
        else
          response = @client.post create_endpoint, create_params

          if response.success?
            @resource_location = response.resource_location
            @id = response.resource_id
          else
            add_errors_from response
          end
        end

        errors.empty?
      end

      private

      # dwolla doesnt accept urls without a scheme
      def website_with_protocol
        return nil unless website.present?

        if website =~ %r{^https?://}
          website
        else
          "http://#{website}"
        end
      end

      def self.fetch_endpoint(id)
        "/customers/#{id}"
      end

      def create_endpoint
        "/customers"
      end
    end
  end
end
