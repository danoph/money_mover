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

  subject { described_class.new(attrs, client) }

  let(:response) { double 'response', code: response_code, headers: response_headers }
  let(:response_code) { 201 }
  let(:response_headers) { { location: resource_location } }

  let(:resource_id) { 'some-resource-id' }
  let(:resource_location) { "http://api-url.com/something/#{resource_id}" }

  let(:customer_token) { 'customer-token' }

  let(:request_params) {{
    name: name,
    type: type,
    routingNumber: routing_number,
    accountNumber: account_number
  }}

  describe '#save' do
    it 'creates new customer in dwolla' do
      expect(client).to receive(:post).with(dwolla_helper.customer_funding_sources_endpoint(customer_token), request_params) { response }

      expect(subject.save).to eq(true)

      expect(subject.id).to eq(resource_id)
      expect(subject.resource_location).to eq(resource_location)
    end
  end
end
