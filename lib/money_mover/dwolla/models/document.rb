module MoneyMover
  module Dwolla
    class Document < ApiResource
      attr_accessor :customer_id, :file, :documentType

      validates_presence_of :customer_id, :file, :documentType

      private

      def create_endpoint
        "/customers/#{customer_id}/documents"
      end

      def create_params
        {
          documentType: documentType,
          file: Faraday::UploadIO.new(file, file.content_type)
        }
      end
    end
  end
end
