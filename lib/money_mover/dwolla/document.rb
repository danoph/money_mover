module MoneyMover
  module Dwolla
    class Document < ApiResource
      attr_accessor :id, :customer_id, :documentType, :file

      validates_presence_of :customer_id, :documentType, :file

      private

      def endpoint
        "customers/#{customer_id}/documents"
      end

      def request_params
        {
          documentType: documentType,
          file: File.new(file, 'rb')
        }
      end
    end
  end
end
