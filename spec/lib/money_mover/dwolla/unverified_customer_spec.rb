require 'spec_helper'

describe MoneyMover::Dwolla::UnverifiedCustomer do
  let(:firstName) { double 'first name' }
  let(:lastName) { double 'last name' }
  let(:email) { double 'email' }
  let(:ipAddress) { double 'ip address' }

  let(:attrs) {{
    firstName: firstName,
    lastName: lastName,
    email: email,
    ipAddress: ipAddress
  }}

  let(:client) { double 'client' }

  subject { described_class.new(attrs, client) }

  let(:response) { double 'response', code: response_code, headers: response_headers }
  let(:response_code) { 201 }
  let(:response_headers) { { location: resource_location } }

  let(:resource_id) { 'some-resource-id' }
  let(:resource_location) { "http://api-url.com/something/#{resource_id}" }

  let(:customers_endpoint) { "https://api-uat.dwolla.com/customers" }

  let(:request_params) {{
    firstName: firstName,
    lastName: lastName,
    email: email,
    ipAddress: ipAddress
  }}

  describe '#save' do
    it 'creates new customer in dwolla' do
      expect(client).to receive(:post).with(customers_endpoint, request_params) { response }

      expect(subject.save).to eq(true)

      expect(subject.id).to eq(resource_id)
      expect(subject.resource_location).to eq(resource_location)
    end
  end
end
