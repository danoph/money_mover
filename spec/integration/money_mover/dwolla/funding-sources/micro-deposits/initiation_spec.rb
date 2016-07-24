require 'spec_helper'

describe MoneyMover::Dwolla::MicrodepositInitiation do
  let(:funding_source_token) { '9481924a-6795-4e7a-b436-a7a48a4141ca' }

  let(:attrs) {{
    funding_source_id: funding_source_token,
  }}

  subject { described_class.new(attrs) }

  let(:create_params) {{}}

  before do
    dwolla_helper.stub_funding_source_microdeposits_request funding_source_token, create_params, create_response
  end

  let(:resource_created_location) { 'https://some-url.com' }

  describe '#save' do
    context 'success' do
      let(:create_response) {{
        status: 201,
        body: ""
      }}

      it 'creates new resource in dwolla' do
        expect(subject.save).to eq(true)
      end
    end

    context 'fail' do
      let(:create_response) {{
        status: 400,
        body: error_response.to_json
      }}

      let(:error_response) {{
        code: "ValidationError",
        message: "Some error"
      }}

      it 'returns errors' do
        expect(subject.save).to eq(false)
        expect(subject.errors[:base]).to eq(['Some error'])
      end
    end
  end
end
