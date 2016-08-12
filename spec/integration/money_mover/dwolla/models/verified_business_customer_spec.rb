require 'spec_helper'

describe MoneyMover::Dwolla::VerifiedBusinessCustomer do
  let(:firstName) { 'first name' }
  let(:lastName) { 'last name' }
  let(:email) { 'some@example.com' }
  let(:address1) { '123 Anywhere St.' }
  let(:address2) { 'Suite 200' }
  let(:city) { 'St. Louis' }
  let(:state) { 'MO' }
  let(:postalCode) { '63104' }
  let(:dateOfBirth) { '01/28/1970' }
  let(:ssn) { '123456789' }
  let(:phone) { '636-333-3333' }
  let(:businessClassification) { 'some-business-classification' }
  let(:businessType) { 'llc' }
  let(:businessName) { 'Some Company, LLC' }
  let(:ein) { '987654321' }
  let(:doingBusinessAs) { 'Alternate Company Name' }
  let(:website) { 'http://website.com' }
  let(:ipAddress) { '127.0.0.1' }

  # TODO: add test for not being able to set type, status, created, etc. directly...

  subject { described_class.new attrs }

  describe '#save' do
    let(:attrs) {{
      firstName: firstName,
      lastName: lastName,
      email: email,
      address1: address1,
      address2: address2,
      city: city,
      state: state,
      postalCode: postalCode,
      dateOfBirth: dateOfBirth,
      ssn: ssn,
      phone: phone,
      businessClassification: businessClassification,
      businessType: businessType,
      businessName: businessName,
      ein: ein,
      doingBusinessAs: doingBusinessAs,
      website: website,
      ipAddress: ipAddress
    }}

    let(:create_customer_params) {{
      firstName: firstName,
      lastName: lastName,
      email: email,
      address1: address1,
      address2: address2,
      city: city,
      state: state,
      postalCode: postalCode,
      dateOfBirth: dateOfBirth,
      ssn: ssn,
      phone: phone,
      businessClassification: businessClassification,
      businessType: businessType,
      businessName: businessName,
      ein: ein,
      doingBusinessAs: doingBusinessAs,
      website: website,
      ipAddress: ipAddress,
      type: 'business'
    }}

    before do
      dwolla_helper.stub_create_customer_request create_customer_params, create_response
    end

    context 'success' do
      let(:customer_token) { '9481924a-6795-4e7a-b436-a7a48a4141ca' }

      let(:create_response) { dwolla_helper.customer_created_response customer_token }

      it 'creates new customer in dwolla' do
        expect(subject.save).to eq(true)

        expect(subject.id).to eq(customer_token)
        expect(subject.resource_location).to eq(dwolla_helper.customer_endpoint(customer_token))
      end
    end

    context 'fail' do
      let(:create_response) { dwolla_helper.resource_create_error_response error_response }

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

        expect(subject.id).to be_nil
        expect(subject.resource_location).to be_nil
      end
    end
  end
end
