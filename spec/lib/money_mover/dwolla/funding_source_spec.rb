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

  subject { described_class.new(attrs) }

  let(:response) { double 'response', code: response_code, headers: response_headers }
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

  let(:create_url) { [ 'customers', customer_token, 'funding-sources' ].join '/' }

  let(:client) { double 'client' }

  before do
    allow(MoneyMover::Dwolla::ApiClient).to receive(:new) { client }
  end

  describe '#save' do
    context 'success' do
      let(:response_code) { 201 }

      it 'adds id and resource location, returns true' do
        expect(client).to receive(:post).with(create_url, request_params) { response }

        expect(subject.save).to eq(true)

        expect(subject.id).to eq(resource_id)
        expect(subject.resource_location).to eq(resource_location)
      end
    end

    context 'fail' do
      let(:response_code) { 400 }

      it 'returns false' do
        expect(client).to receive(:post).with(create_url, request_params) { response }

        expect(subject.save).to eq(false)

        expect(subject.id).to be_nil
        expect(subject.resource_location).to be_nil
      end
    end
  end
end
