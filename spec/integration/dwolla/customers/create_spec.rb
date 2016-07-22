require 'spec_helper'

describe MoneyMover::Dwolla::UnverifiedCustomer do
  let(:first_name) { 'first name' }
  let(:last_name) { 'last name' }
  let(:email) { 'some@example.com' }
  let(:ip_address) { '127.0.0.1' }

  let(:attrs) {{
    first_name: first_name,
    last_name: last_name,
    email: email,
    ip_address: ip_address
  }}

  subject { described_class.new(attrs) }

  let(:dwolla_endpoint) { "https://api-uat.dwolla.com" }

  let(:customer_token) { '9481924a-6795-4e7a-b436-a7a48a4141ca' }

  let(:create_customer_endpoint) { "#{dwolla_endpoint}/customers" }

  let(:customer_created_response) {{
    status: 201,
    body: "",
    headers: {
      location: customer_resource_location
    }
  }}

  let(:customer_resource_location) { "#{dwolla_endpoint}/customers/#{customer_token}" }

  let(:dwolla_create_customer_params) {{
    firstName: first_name,
    lastName: last_name,
    email: email,
    ipAddress: ip_address
  }}

  let(:access_token) { "X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak" }

  let(:dwolla_request_headers) {{
    'Accept'=>'application/vnd.dwolla.v1.hal+json',
    'Accept-Encoding'=>'gzip, deflate',
    'Authorization'=>"Bearer #{access_token}",
    'Content-Type'=>'application/json',
  }}

  before do
    stub_request(:post, create_customer_endpoint).
      with(body: dwolla_create_customer_params, headers: dwolla_request_headers).
      to_return(customer_created_response)
  end

  describe '#save' do
    it 'creates new customer in dwolla' do
      expect(subject.save).to eq(true)
      expect(subject.id).to eq(customer_token)
      expect(subject.resource_location).to eq(customer_resource_location)
    end
  end
end
