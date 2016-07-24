require 'spec_helper'

describe MoneyMover::Dwolla::Transfer do
  let(:funding_source_resource_location) { 'some-resource-location' }
  let(:funding_destination_resource_location) { 'some-resource-location' }
  let(:amount) { 10.0 }
  let(:metadata) {{}}

  let(:attrs) {{
    funding_source_resource_location: funding_source_resource_location,
    funding_destination_resource_location: funding_destination_resource_location,
    amount: amount,
    metadata: metadata
  }}

  subject { described_class.new(attrs) }

  let(:create_params) {{
    _links: {
      destination: {
        href: funding_source_resource_location
      },
      source: {
        href: funding_destination_resource_location
      }
    },
    amount: {
      value: amount.to_s,
      currency: "USD"
    },
    metadata: metadata
  }}

  let(:resource_token) { 'some-token' }

  before do
    dwolla_helper.set_access_token
    dwolla_helper.stub_create_transfer_request create_params, create_response
  end

  describe '#save' do
    context 'success' do
      let(:create_response) { dwolla_helper.transfer_created_response resource_token }

      it 'creates new resource in dwolla' do
        expect(subject.save).to eq(true)
        expect(subject.id).to eq(resource_token)
        expect(subject.resource_location).to eq(dwolla_helper.transfer_endpoint(resource_token))
      end
    end

    context 'fail' do
      let(:create_response) { dwolla_helper.resource_create_error_response error_response }

      let(:error_response) {{
        code: "ValidationError",
        message: "Validation error(s) present. See embedded errors list for more details.",
        _embedded: {
          errors: [
            { code: "Duplicate", message: "Invalid destination", path: "/_links/destination/href"
          }
          ]
        }
      }}

      it 'returns errors' do
        expect(subject.save).to eq(false)
        expect(subject.errors[:_links]).to eq(['Invalid destination'])
        expect(subject.id).to be_nil
        expect(subject.resource_location).to be_nil
      end
    end
  end
end
