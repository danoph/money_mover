require 'spec_helper'

describe MoneyMover::Dwolla::FundingSource do
  let(:name) { double 'name' }
  let(:type) { double 'type' }
  let(:routing_number) { double 'routing number' }
  let(:account_number) { double 'account number' }

  let(:attrs) {{
    customer_id: customer_token,
    name: name,
    type: type,
    routing_number: routing_number,
    account_number: account_number
  }}

  let(:client) { double 'client' }

  subject { described_class.new(attrs) }

  let(:response) { double 'response', code: response_code, headers: response_headers }
  let(:response_code) { 201 }
  let(:response_headers) { { location: resource_location } }

  let(:resource_id) { 'some-resource-id' }
  let(:resource_location) { "http://api-url.com/something/#{resource_id}" }

  let(:customer_token) { 'customer-token' }

  let(:customer_funding_sources_endpoint) { "https://api-uat.dwolla.com/customers/#{customer_token}/funding-sources" }

  let(:request_params) {{
    name: name,
    type: type,
    routingNumber: routing_number,
    accountNumber: account_number
  }}

  let(:request_headers) {{
    content_type: :json,
    accept: 'application/vnd.dwolla.v1.hal+json',
    Authorization: "Bearer #{access_token}"
  }}

  let(:access_token) { 'X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak' }

  describe '#save' do
    it 'creates new customer in dwolla' do
      expect(RestClient).to receive(:post).with(customer_funding_sources_endpoint, request_params.to_json, request_headers) { response }

      expect(subject.save).to eq(true)

      expect(subject.id).to eq(resource_id)
      expect(subject.resource_location).to eq(resource_location)
    end
  end
end
