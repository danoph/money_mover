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

  subject { described_class.new(attrs) }

  let(:response) { double 'response', success?: success?, errors: response_errors, resource_id: resource_id, resource_location: resource_location }
  let(:response_errors) { { email: 'invalid' } }

  let(:resource_id) { 'some-resource-id' }
  let(:resource_location) { "http://api-url.com/something/#{resource_id}" }

  let(:request_params) {{
    firstName: firstName,
    lastName: lastName,
    email: email,
    ipAddress: ipAddress
  }}

  let(:create_url) { 'customers' }

  before do
    allow(MoneyMover::Dwolla::ApiPostRequest).to receive(:new).with(create_url, request_params) { response }
  end

  describe '#save' do
    context 'success' do
      let(:success?) { true }

      it 'adds id and resource location, returns true' do
        expect(subject.save).to eq(true)
        expect(subject.errors).to eq({})

        expect(subject.id).to eq(resource_id)
        expect(subject.resource_location).to eq(resource_location)
      end
    end

    context 'fail' do
      let(:success?) { false }

      it 'returns false' do
        expect(subject.save).to eq(false)
        expect(subject.errors).to eq(response_errors)

        expect(subject.id).to be_nil
        expect(subject.resource_location).to be_nil
      end
    end
  end
end
