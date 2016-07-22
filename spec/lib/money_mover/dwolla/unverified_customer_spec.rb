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

  subject { described_class.new(attrs) }

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

  let(:request_headers) {{
    content_type: :json,
    accept: 'application/vnd.dwolla.v1.hal+json',
    Authorization: "Bearer #{access_token}"
  }}

  let(:access_token) { 'X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak' }

  describe '#save' do
    it 'creates new customer in dwolla' do
      expect(RestClient).to receive(:post).with(customers_endpoint, request_params.to_json, request_headers) { response }

      expect(subject.save).to eq(true)

      expect(subject.id).to eq(resource_id)
      expect(subject.resource_location).to eq(resource_location)
    end
  end
end
