module MoneyMover
  module Dwolla
    class RequestSignatureValidator
      include ActiveModel::Model
      validate :valid_request_signature

      def initialize(ach_webhook_secret_key, request_body, request_headers)
        @ach_webhook_secret_key = ach_webhook_secret_key
        @request_body = request_body
        @ach_request_signature = request_headers['HTTP_X_REQUEST_SIGNATURE_SHA_256']
      end

      def valid_request_signature
        unless @ach_request_signature && Rack::Utils.secure_compare(signed_body, @ach_request_signature)
          errors.add :base, "Request Signature Invalid"
        end
      end

      def signed_body
        OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new("sha256"), @ach_webhook_secret_key, @request_body.string)
      end
    end
  end
end
