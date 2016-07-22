module MoneyMover
  module Dwolla
    class ApiClient
      def post(url, request_params)
        RestClient.post url, request_params.to_json, request_headers
      end

      private

      def access_token
        'X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak'
      end

      def request_headers
        {
          content_type: :json,
          accept: 'application/vnd.dwolla.v1.hal+json',
          Authorization: "Bearer #{access_token}"
        }
      end
    end
  end
end
