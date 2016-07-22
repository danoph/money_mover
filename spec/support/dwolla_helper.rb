require 'webmock'

class DwollaHelper
  include WebMock::API

  def access_token
    "X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak"
  end

  def api_endpoint
    "https://api-uat.dwolla.com"
  end

  def customers_endpoint
    'customers'
  end

  def customer_endpoint(customer_token)
    [ customers_endpoint, customer_token ].join '/'
  end

  def customer_funding_sources_endpoint(customer_token)
    [ customer_endpoint(customer_token), 'funding-sources' ].join '/'
  end

  def customer_funding_source_endpoint(customer_token, funding_source_token)
    [ customer_funding_sources_endpoint(customer_token), funding_source_token ].join '/'
  end

  def request_headers
    {
      'Accept'=>'application/vnd.dwolla.v1.hal+json',
      'Accept-Encoding'=>'gzip, deflate',
      'Authorization'=>"Bearer #{access_token}",
      'Content-Type'=>'application/json',
    }
  end

  def customer_created_response(customer_token)
    resource_created_response customer_endpoint(customer_token)
  end

  def customer_funding_source_created_response(customer_token, funding_source_token)
    resource_created_response customer_funding_source_endpoint(customer_token, funding_source_token)
  end

  def resource_created_response(resource_location)
    {
      status: 201,
      body: "",
      headers: {
        location: resource_location
      }
    }
  end

  def resource_create_error_response(response_body)
    {
      status: 400,
      body: response_body.to_json,
      headers: {"Content-Type" => "application/json"}
    }
  end

  def stub_create_customer_request(params, response)
    stub_post_request customers_endpoint, params, response
  end

  def stub_create_customer_funding_source_request(customer_token, params, response)
    stub_post_request customer_funding_sources_endpoint(customer_token), params, response
  end

  def stub_find_customer_request(customer_token, response)
    stub_get_request customer_endpoint(customer_token), response
  end

  def stub_get_request(url, response)
    stub_request(:get, build_dwolla_url(url)).with(headers: request_headers).to_return(response)
  end

  def stub_post_request(url, params, response)
    stub_request(:post, build_dwolla_url(url)).with(body: params, headers: request_headers).to_return(response)
  end

  def build_dwolla_url(url)
    [ api_endpoint, url ].join '/'
  end
end
