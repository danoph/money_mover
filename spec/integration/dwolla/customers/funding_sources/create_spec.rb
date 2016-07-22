require 'spec_helper'

describe MoneyMover::Dwolla::FundingSource do
  let(:name) { 'my checking account' }
  let(:type) { 'checking' }
  let(:routing_number) { '222222226' }
  let(:account_number) { '9393' }

  let(:attrs) {{
    customer_id: customer_token,
    name: name,
    type: type,
    routing_number: routing_number,
    account_number: account_number
  }}

  subject { described_class.new(attrs) }

  let(:dwolla_endpoint) { "https://api-uat.dwolla.com" }

  let(:customer_token) { '9481924a-6795-4e7a-b436-a7a48a4141ca' }
  let(:funding_source_token) { 'FC451A7A-AE30-4404-AB95-E3553FCD733F' }

  let(:create_customer_funding_source_endpoint) { "#{dwolla_endpoint}/customers/#{customer_token}/funding-sources" }

  let(:funding_source_created_response) {{
    status: 201,
    body: "",
    headers: {
      location: funding_source_resource_location
    }
  }}

  let(:funding_source_resource_location) { "#{dwolla_endpoint}/funding-sources/#{funding_source_token}" }

  let(:dwolla_create_funding_source_params) {{
    name: name,
    type: type,
    routingNumber: routing_number,
    accountNumber: account_number
  }}

  let(:access_token) { "X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak" }

  let(:dwolla_request_headers) {{
    'Accept'=>'application/vnd.dwolla.v1.hal+json',
    'Accept-Encoding'=>'gzip, deflate',
    'Authorization'=>"Bearer #{access_token}",
    'Content-Type'=>'application/json',
  }}

  before do
    stub_request(:post, create_customer_funding_source_endpoint).
      with(body: dwolla_create_funding_source_params, headers: dwolla_request_headers).
      to_return(funding_source_created_response)
  end

  describe '#save' do
    it 'creates new customer funding source in dwolla' do
      expect(subject.save).to eq(true)
      expect(subject.id).to eq(funding_source_token)
      expect(subject.resource_location).to eq(funding_source_resource_location)
    end
  end
end
