require 'spec_helper'

describe MoneyMover::Dwolla::FundingSource do
  let(:name) { double 'name' }
  let(:type) { double 'type' }
  let(:routingNumber) { double 'routing number' }
  let(:accountNumber) { double 'account number' }

  let(:attrs) {{
    customer_id: customer_token,
    name: name,
    type: type,
    routingNumber: routingNumber,
    accountNumber: accountNumber
  }}

  subject { described_class.new(attrs) }

  let(:response) { double 'response', success?: success?, resource_location: resource_location, resource_id: resource_id }
  let(:resource_id) { 'some-resource-id' }
  let(:resource_location) { "http://api-url.com/something/#{resource_id}" }

  let(:customer_token) { 'customer-token' }

  let(:request_params) {{
    name: name,
    type: type,
    routingNumber: routingNumber,
    accountNumber: accountNumber
  }}

  let(:create_url) { [ 'customers', customer_token, 'funding-sources' ].join '/' }

  before do
    allow(MoneyMover::Dwolla::ApiPostRequest).to receive(:new).with(create_url, request_params) { response }
  end

  describe '#save' do
    context 'success' do
      let(:success?) { true }

      it 'adds id and resource location, returns true' do
        expect(subject.save).to eq(true)

        expect(subject.id).to eq(resource_id)
        expect(subject.resource_location).to eq(resource_location)
      end
    end

    context 'fail' do
      let(:success?) { false }

      it 'returns false' do
        expect(subject.save).to eq(false)

        expect(subject.id).to be_nil
        expect(subject.resource_location).to be_nil
      end
    end
  end
end
