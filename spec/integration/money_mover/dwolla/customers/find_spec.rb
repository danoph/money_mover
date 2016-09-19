require 'spec_helper'

describe MoneyMover::Dwolla::Customer do
  let(:customer_token) { '9481924a-6795-4e7a-b436-a7a48a4141ca' }

  let(:firstName) { 'first name' }
  let(:lastName) { 'last name' }
  let(:email) { 'email@example.com' }
  let(:ipAddress) { '127.0.0.1' }

  before do
    dwolla_helper.stub_find_customer_request customer_token, customer_response
  end

  describe '.find' do
    subject { described_class.find(customer_token) }

    context 'success' do
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
        body: customer_response_object.to_json,
        headers: {
          'Content-Type' => 'application/json'
        }
      }}

      it 'returns customer' do
        expect(subject.id).to eq(customer_token)
        #expect(subject.resource_location).to eq(dwolla_helper.customer_endpoint(customer_token))
        expect(subject.firstName).to eq(firstName)
        expect(subject.lastName).to eq(lastName)
        expect(subject.email).to eq(email)
        expect(subject.ipAddress).to eq(ipAddress)
      end

      context 'real response' do
        let(:customer_token) { '7bc7e791-47f7-457d-b15d-ab4d92d46343' }
        let(:customer_response_filename) { File.expand_path '../../../../../support/dwolla_responses/customer_response.json', __FILE__ }
        let(:customer_response_object) { JSON.parse File.read(customer_response_filename), symbolize_names: true }

        it 'returns customer' do
          expect(subject.id).to eq(customer_token)
          #expect(subject.resource_location).to eq(dwolla_helper.customer_endpoint(customer_token))
          expect(subject.firstName).to eq('retry')
          expect(subject.lastName).to eq('Retrya2 Last Name')
          expect(subject.email).to eq(email)
        end
      end
    end

    context 'failure' do
      let(:response_body) {{
        code: 'Something',
        message: 'Customer not found.'
      }}

      let(:customer_response) {{
        status: 404,
        body: response_body.to_json
      }}

      it 'returns errors' do
        expect { subject }.to raise_error('Customer Not Found')
      end
    end
  end
end
