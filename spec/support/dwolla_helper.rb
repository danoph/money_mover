require 'webmock'

class TestConfigProvider
  def access_token
    "X7JyEzy6F85MeDZERFE2cgiLbm9TXIbQNmr16cCfI6y1CtPrak"
  end

  def refresh_token
    "Qlj3SFaIGPJmeFrPEJsPI6smKwdXLsPYAYi83lXkqeb8q0MX1P"
  end

  def application_token
    "SF8Vxx6H644lekdVKAAHFnqRCFy8WGqltzitpii6w2MVaZp1Nw"
  end

  def environment
    :sandbox
  end

  def api_key
    "IkvGNVjFLJTBZeWsqFdHMppbuG2g4kTY1WFxz1HUjusxZ71eMz"
  end

  def api_secret_key
    "lB9gPl6xyqLIiKF9al1K8e2sXhNyvjkrsTMUFKs176oXsSo2K9"
  end

  def webhook_secret_key
    "20f2f952eb91071ab655d5522d7d246177b3fbbe8fe878df80be36a0fa2c4c6f7d1e981038d55aae40e5325d6377b0b4be78375c6566c74a7c9fdba7008daf58"
  end

  def webhook_callback_url
    "http://buildpay.sprouti.com/ach/events"
  end

  def account_token_provider
    TestDwollaTokenProvider
  end
end

class TestDwollaTokenProvider
  def access_token
    "X7JyEzy6F85MeDZERFE2cgiLbm9TXIbQNmr16cCfI6y1CtPrak"
  end

  def refresh_token
    "Qlj3SFaIGPJmeFrPEJsPI6smKwdXLsPYAYi83lXkqeb8q0MX1P"
  end
end

class DwollaHelper
  include WebMock::API

  def initialize
    @config_provider = TestConfigProvider.new
  end

  def access_token
    @config_provider.access_token
  end

  def refresh_token
    @config_provider.refresh_token
  end

  def application_token
    @config_provider.application_token
  end

  def api_key
    @config_provider.api_key
  end

  def api_secret_key
    @config_provider.api_secret_key
  end

  def webhook_secret_key
    @config_provider.webhook_secret_key
  end

  def webhook_callback_url
    @config_provider.webhook_callback_url
  end

  def api_url
    "https://api-uat.dwolla.com"
  end

  def api_endpoint
    api_url
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
      #'Accept-Encoding'=>'gzip, deflate',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>"Bearer #{access_token}",
      #'Content-Type'=>'application/json',
    }
  end

  def customer_created_response(customer_token)
    resource_created_response customer_endpoint(customer_token)
  end

  def transfer_created_response(transfer_token)
    resource_created_response transfer_endpoint(transfer_token)
  end

  def customer_document_created_response(resource_token)
    resource_created_response document_endpoint(resource_token)
  end

  def customer_funding_source_created_response(customer_token, funding_source_token)
    resource_created_response customer_funding_source_endpoint(customer_token, funding_source_token)
  end

  def customer_documents_endpoint(customer_token)
    [ customer_endpoint(customer_token), "documents" ].join '/'
  end

  def funding_sources_endpoint
    "funding-sources"
  end

  def documents_endpoint
    "documents"
  end

  def document_endpoint(resource_token)
    [ documents_endpoint, resource_token ].join '/'
  end

  def funding_source_endpoint(funding_source_token)
    [ funding_sources_endpoint, funding_source_token ].join '/'
  end

  def funding_source_microdeposits_endpoint(funding_source_token)
    [ funding_source_endpoint(funding_source_token), "micro-deposits" ].join '/'
  end

  def transfers_endpoint
    "transfers"
  end

  def transfer_endpoint(transfer_token)
    [ transfers_endpoint, transfer_token ].join '/'
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

  def stub_funding_source_microdeposits_request(funding_source_token, create_params, response)
    stub_post_request funding_source_microdeposits_endpoint(funding_source_token), create_params, response
  end

  def stub_create_transfer_request(params, response)
    stub_post_request transfers_endpoint, params, response
  end

  def stub_create_customer_document_request(customer_token, params, response)
    stub_post_request customer_documents_endpoint(customer_token), params, response
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

  # taken from ach_helper

  def get_token_url
    "https://uat.dwolla.com/oauth/v2/token"
  end

  def error_response(body_json = {})
    {
      status: 400,
      body: body_json.to_json,
      headers: {"Content-Type" => "application/json"}
    }
  end

  def stub_get_token_request(token_response = nil)
    token_response ||= {
      "access_token": application_token,
      "token_type": "bearer",
      "expires_in": 3600,
      "scope": "AccountInfoFull|ManageAccount|Contacts|Transactions|Balance|Send|Request|Funding"
    }

    req_body = {
      grant_type: "client_credentials",
      client_id: api_key,
      client_secret: api_secret_key
    }

    stub_request(:post, get_token_url).
    with(:body => req_body).
      to_return(status: 200, body: token_response.to_json, headers: {"Content-Type" => "application/json"})
  end

  def stub_refresh_token_request(token_response)
    req_body = {
      grant_type: "refresh_token",
      client_id: api_key,
      client_secret: api_secret_key,
      refresh_token: refresh_token
    }

    req_headers = {
      'Accept'=>'application/vnd.dwolla.v1.hal+json',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Faraday v0.9.2'
    }

    stub_request(:post, get_token_url).with(body: req_body, headers: req_headers).
      to_return(:status => 200, :body => token_response.to_json, headers: {"Content-Type" => "application/json"})
  end

  def webhook_subscriptions_url
    "#{api_url}/webhook-subscriptions"
  end

  def webhook_subscription_url(webhook_token)
    "#{api_url}/webhook-subscriptions/#{webhook_token}"
  end

  def stub_get_webhook_subscriptions_request(stub_response)
    stub_request(:get, webhook_subscriptions_url).
      with(headers: dwolla_application_request_headers).
      to_return(body: stub_response.to_json, headers: {"Content-Type" => "application/json"})
  end

  def stub_create_webhook_subscription_request(stub_params, stub_response)
    stub_request(:post, webhook_subscriptions_url).
      with(headers: dwolla_application_request_headers, body: stub_params).
    to_return(stub_response)
  end

  def stub_delete_webhook_subscription_request(subscription_id, stub_response)
    stub_request(:delete, webhook_subscription_url(subscription_id)).
      with(headers: dwolla_application_request_headers).
    to_return(stub_response)
  end

  def dwolla_application_request_headers
    {
      'Accept'=>'application/vnd.dwolla.v1.hal+json',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'Authorization'=>"Bearer #{application_token}",
      'User-Agent'=>'Faraday v0.9.2'
    }
  end

  def create_webhook_success_response(webhook_token)
    resource_created_response webhook_subscription_url(webhook_token)
  end

  def resource_deleted_response
    {
      status: 200,
      body: ""
    }
  end

  def create_customer_success_response(customer_token)
    resource_created_response customer_url(customer_token)
  end

  def customers_url
    "#{api_url}/customers"
  end

  def customer_url(customer_token)
    "#{customers_url}/#{customer_token}"
  end
end
