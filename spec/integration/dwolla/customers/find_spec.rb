require 'spec_helper'

describe MoneyMover::Dwolla::Customer do
  let(:customer_token) { '9481924a-6795-4e7a-b436-a7a48a4141ca' }

  let(:firstName) { 'first name' }
  let(:lastName) { 'last name' }
  let(:email) { 'email@example.com' }
  let(:ipAddress) { '127.0.0.1' }

  let(:timestamp) { DateTime.now.to_s }

  let(:customer_response_object) {{
    _links: {
      self: {
        href: dwolla_helper.customer_endpoint(customer_token)
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

  before do
    dwolla_helper.stub_find_customer_request customer_token, customer_response
  end

  describe '.find' do
    subject { described_class.find(customer_token) }

    it 'creates new customer in dwolla' do
      expect(subject.id).to eq(customer_token)
      expect(subject.resource_location).to eq(dwolla_helper.customer_endpoint(customer_token))
      expect(subject.firstName).to eq(firstName)
      expect(subject.lastName).to eq(lastName)
      expect(subject.email).to eq(email)
      expect(subject.ipAddress).to eq(ipAddress)
    end
  end
end
