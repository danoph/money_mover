require 'spec_helper'

describe MoneyMover::Dwolla::VerifiedBusinessCustomer do
  let(:firstName) { double 'first name' }
  let(:lastName) { double 'last name' }
  let(:email) { double 'email' }
  let(:address1) { double 'address 1' }
  let(:address2) { double 'address 2' }
  let(:city) { double 'city' }
  let(:state) { double 'state' }
  let(:postalCode) { double 'postal code' }
  let(:dateOfBirth) { double 'dob' }
  let(:ssn) { double 'ssn' }
  let(:phone) { double 'phone' }
  let(:businessClassification) { double 'business classification' }
  let(:businessType) { double 'business type' }
  let(:businessName) { double 'business name' }
  let(:ein) { double 'ein' }
  let(:doingBusinessAs) { double 'dba' }
  let(:website) { 'www.buildpay.co' }
  let(:ipAddress) { double 'ip address' }

  # TODO: add test for not being able to set type, status, created, etc. directly...

  let(:account_client) { double 'account client' }

  subject { described_class.new attrs, account_client }

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
      website: website_with_protocol,
      ipAddress: ipAddress,
      type: 'business'
    }}

    let(:website_with_protocol) { "http://#{website}" }

    let(:dwolla_response) { double 'dwolla response', success?: success?, resource_id: resource_id, resource_location: resource_location, errors: dwolla_errors }
    let(:resource_id) { double 'resource id' }
    let(:resource_location) { double 'resource location' }
    let(:dwolla_errors) {{
      errorKey1: 'some error 1',
      errorKey2: 'some error 2'
    }}

    let(:create_endpoint) { "/customers" }

    before do
      allow(account_client).to receive(:post).with(create_endpoint, create_customer_params) { dwolla_response }
    end

    shared_examples 'resource created successfully' do
      it 'returns true' do
        expect(subject.save).to eq(true)
        expect(subject.errors.count).to eq(0)

        expect(subject.id).to eq(resource_id)
        expect(subject.resource_location).to eq(resource_location)
      end
    end

    context 'success' do
      let(:success?) { true }

      it_behaves_like "resource created successfully"

      context 'only required fields sent' do
        let(:attrs) {{
          firstName: firstName,
          lastName: lastName,
          email: email,
          address1: address1,
          city: city,
          state: state,
          postalCode: postalCode,
          dateOfBirth: dateOfBirth,
          ssn: ssn,
          phone: phone,
          businessClassification: businessClassification,
          businessType: businessType,
          businessName: businessName,
          ein: ein
        }}

        let(:create_customer_params) {{
          firstName: firstName,
          lastName: lastName,
          email: email,
          address1: address1,
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
          doingBusinessAs: businessName,
          type: 'business'
        }}

        it_behaves_like "resource created successfully"
      end

      context 'sending empty strings for non-required fields' do
        let(:attrs) {{
          firstName: firstName,
          lastName: lastName,
          email: email,
          address1: address1,
          address2: "",
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
          doingBusinessAs: "",
          website: "",
          ipAddress: ""
        }}

        let(:create_customer_params) {{
          firstName: firstName,
          lastName: lastName,
          email: email,
          address1: address1,
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
          doingBusinessAs: businessName,
          type: 'business'
        }}

        it_behaves_like "resource created successfully"
      end

      context 'using https for website protocol' do
        let(:website) { 'https://something.com' }
        let(:website_with_protocol) { 'https://something.com' }

        it_behaves_like "resource created successfully"
      end
    end

    context 'fail' do
      let(:success?) { false }

      it 'returns errors' do
        expect(subject.save).to eq(false)

        expect(subject.errors[:errorKey1]).to eq(['some error 1'])
        expect(subject.errors[:errorKey2]).to eq(['some error 2'])

        expect(subject.id).to be_nil
        expect(subject.resource_location).to be_nil
      end
    end
  end
end
