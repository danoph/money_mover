require 'spec_helper'

describe MoneyMover::Dwolla::UnverifiedCustomer do
  let(:first_name) { double 'first name' }
  let(:last_name) { double 'last name' }
  let(:email) { double 'email' }
  let(:ip_address) { double 'ip address' }

  let(:attrs) {{
    first_name: first_name,
    last_name: last_name,
    email: email,
    ip_address: ip_address
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
    firstName: first_name,
    lastName: last_name,
    email: email,
    ipAddress: ip_address
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
