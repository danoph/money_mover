require 'spec_helper'

describe MoneyMover::Dwolla::Document do
  let(:customer_id) { 'customer-id' }
  let(:file) { File.expand_path('../../../../../support/fixtures/sample.jpg', __FILE__) }
  let(:documentType) { 'other' }

  let(:attrs) {{
    customer_id: customer_id,
    documentType: 'other',
    file: file
  }}

  subject { described_class.new(attrs) }

  let(:create_params) {{
    documentType: documentType,
    file: File.new(file, 'rb')
  }}

  let(:resource_token) { 'some-token' }

  before do
    dwolla_helper.stub_request(:post, dwolla_helper.build_dwolla_url(dwolla_helper.customer_documents_endpoint(customer_id))).with(headers: dwolla_helper.request_headers).to_return(create_response)
  end

  describe '#save' do
    context 'success' do
      let(:create_response) { dwolla_helper.customer_document_created_response resource_token }

      it 'creates new resource in dwolla' do
        expect(subject.save).to eq(true)
        expect(subject.id).to eq(resource_token)
        expect(subject.resource_location).to eq(dwolla_helper.document_endpoint(resource_token))
      end
    end

    context 'fail' do
      let(:create_response) { dwolla_helper.resource_create_error_response error_response }

      let(:error_response) {{
        code: "ValidationError",
        message: "Validation error(s) present. See embedded errors list for more details.",
        _embedded: {
          errors: [
            { code: "Invalid", message: "Invalid parameter.", path: "/file"
          }
          ]
        }
      }}

      it 'returns errors' do
        expect(subject.save).to eq(false)
        expect(subject.errors[:file]).to eq(['Invalid parameter.'])
        expect(subject.id).to be_nil
        expect(subject.resource_location).to be_nil
      end
    end
  end
end
