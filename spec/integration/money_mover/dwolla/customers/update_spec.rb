require 'spec_helper'

describe MoneyMover::Dwolla::UnverifiedCustomer do
  let(:customer_token) { '9481924a-6795-4e7a-b436-a7a48a4141ca' }
  let(:firstName) { 'first name' }
  let(:lastName) { 'last name' }
  let(:email) { 'some@example.com' }
  let(:ipAddress) { '127.0.0.1' }

  let(:attrs) {{
    id: customer_token,
    firstName: firstName,
    lastName: lastName,
    email: email,
    ipAddress: ipAddress
  }}

  subject { described_class.new attrs }

  let(:update_customer_params) {{
    firstName: firstName,
    lastName: lastName,
    email: email,
    ipAddress: ipAddress,
    type: 'unverified'
  }}

  before do
    dwolla_helper.stub_update_customer_request customer_token, update_customer_params, update_response
  end

  describe '#save' do
    context 'success' do
      let(:update_response) do
        {
          status: 200,
          body: ""
        }
      end

      it 'creates new customer in dwolla' do
        expect(subject.save).to eq(true)
      end
    end

    context 'fail' do
      let(:update_response) { dwolla_helper.resource_create_error_response error_response }

      let(:error_response) {{
        code: "ValidationError",
        message: "Validation error(s) present. See embedded errors list for more details.",
        _embedded: {
          errors: [
            { code: "Duplicate", message: "A customer with the specified email already exists.", path: "/email"
          }
          ]
        }
      }}

      it 'returns errors' do
        expect(subject.save).to eq(false)
        expect(subject.errors[:email]).to eq(['A customer with the specified email already exists.'])
        expect(subject.id).to eq(customer_token)
        expect(subject.resource_location).to be_nil
      end
    end
  end
end
