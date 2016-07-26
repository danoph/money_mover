require 'spec_helper'

describe MoneyMover::Dwolla::FundingSource do
  let(:name) { 'my checking account' }
  let(:type) { 'checking' }
  let(:routingNumber) { '222222226' }
  let(:accountNumber) { '9393' }

  let(:attrs) {{
    #customer_id: customer_token,
    name: name,
    type: type,
    routingNumber: routingNumber,
    accountNumber: accountNumber
  }}

  subject { described_class.new(customer_token, attrs) }

  let(:customer_token) { '9481924a-6795-4e7a-b436-a7a48a4141ca' }
  let(:funding_source_token) { 'FC451A7A-AE30-4404-AB95-E3553FCD733F' }

  let(:create_params) {{
    name: name,
    type: type,
    routingNumber: routingNumber,
    accountNumber: accountNumber
  }}

  before do
    dwolla_helper.stub_create_customer_funding_source_request customer_token, create_params, dwolla_helper.customer_funding_source_created_response(customer_token, funding_source_token)
  end

  describe '#save' do
    it 'creates new customer funding source in dwolla' do
      expect(subject.save).to eq(true)
      expect(subject.id).to eq(funding_source_token)
      expect(subject.resource_location).to eq(dwolla_helper.customer_funding_source_endpoint(customer_token, funding_source_token))
    end
  end
end
