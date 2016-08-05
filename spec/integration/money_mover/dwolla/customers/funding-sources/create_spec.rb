require 'spec_helper'

describe MoneyMover::Dwolla::CustomerFundingSource do
  let(:name) { 'my checking account' }
  let(:type) { 'checking' }
  let(:routingNumber) { '222222226' }
  let(:accountNumber) { '9393' }

  let(:attrs) {{
    #customer_id: customer_token,
    name: name,
    type: type,
    routingNumber: routingNumber,
    accountNumber: accountNumber
  }}

  subject { described_class.new(customer_token, attrs) }

  let(:customer_token) { '9481924a-6795-4e7a-b436-a7a48a4141ca' }
  let(:funding_source_token) { 'FC451A7A-AE30-4404-AB95-E3553FCD733F' }

  let(:create_params) {{
    name: name,
    type: type,
    routingNumber: routingNumber,
    accountNumber: accountNumber
  }}

  before do
    dwolla_helper.stub_create_customer_funding_source_request customer_token, create_params, create_response
  end

  describe '#save' do
    context 'valid' do
      let(:create_response) { dwolla_helper.customer_funding_source_created_response customer_token, funding_source_token }

      it 'creates new customer funding source in dwolla' do
        expect(subject.save).to eq(true)
        expect(subject.id).to eq(funding_source_token)
        expect(subject.resource_location).to eq(dwolla_helper.customer_funding_source_endpoint(customer_token, funding_source_token))
      end
    end

    context 'invalid' do
      let(:create_response) do
        dwolla_helper.error_response(
          code: "ValidationError",
          message: "Validation error(s) present. See embedded errors list for more details.",
          _embedded: {
            errors: [
              {
                code: "Invalid",
                message: "Invalid parameter.",
                path: "/routingNumber"
              }
            ]
          }
        )
      end

      it 'returns false and sets errors' do
        expect(subject.save).to eq(false)
        expect(subject.errors[:routingNumber]).to eq(['Invalid parameter.'])

        expect(subject.id).to be_nil
        expect(subject.resource_location).to be_nil
      end
    end
  end
end
