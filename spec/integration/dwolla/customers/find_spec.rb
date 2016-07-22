require 'spec_helper'

describe MoneyMover::Dwolla::Customer do
  let(:dwolla_endpoint) { "https://api-uat.dwolla.com" }

  let(:customer_token) { '9481924a-6795-4e7a-b436-a7a48a4141ca' }

  let(:firstName) { 'first name' }
  let(:lastName) { 'last name' }
  let(:email) { 'email@example.com' }
  let(:ipAddress) { '127.0.0.1' }

  let(:timestamp) { DateTime.now.to_s }

  let(:customer_response_object) {{
    _links: {
      self: {
        href: customer_resource_location
      }
    },
    id: customer_token,
    firstName: firstName,
    lastName: lastName,
    email: email,
    ipAddress: ipAddress,
    type: 'unverified',
    status: 'unverified',
    created: timestamp
  }}

  let(:customer_response) {{
    status: 200,
    body: customer_response_object.to_json
  }}

  let(:customer_resource_location) { "#{dwolla_endpoint}/customers/#{customer_token}" }

  let(:access_token) { "X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak" }

  let(:dwolla_request_headers) {{
    'Accept'=>'application/vnd.dwolla.v1.hal+json',
    'Accept-Encoding'=>'gzip, deflate',
    'Authorization'=>"Bearer #{access_token}",
    'Content-Type'=>'application/json',
  }}

  before do
    stub_request(:get, customer_resource_location).
      with(headers: dwolla_request_headers).
      to_return(customer_response)
  end

  describe '.find' do
    subject { described_class.find(customer_token) }

    it 'creates new customer in dwolla' do
      expect(subject.id).to eq(customer_token)
      expect(subject.resource_location).to eq(customer_resource_location)
      expect(subject.firstName).to eq(firstName)
      expect(subject.lastName).to eq(lastName)
      expect(subject.email).to eq(email)
    end
  end
end
