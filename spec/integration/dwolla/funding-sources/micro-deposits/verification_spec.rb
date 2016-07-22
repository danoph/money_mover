require 'spec_helper'

describe MoneyMover::Dwolla::MicrodepositVerification do
  let(:funding_source_token) { '9481924a-6795-4e7a-b436-a7a48a4141ca' }

  describe '#save' do
    context 'valid attributes' do
      let(:amount1) { 0.01 }
      let(:amount2) { 0.02 }

      let(:attrs) {{
        funding_source_id: funding_source_token,
        amount1: amount1,
        amount2: amount2
      }}

      subject { described_class.new(attrs) }

      let(:create_params) {{
        amount1: {
          value: amount1,
          currency: "USD"
        },
        amount2: {
          value: amount2,
          currency: "USD"
        }
      }}

      before do
        dwolla_helper.stub_funding_source_microdeposits_request funding_source_token, create_params, create_response
      end

      context 'success' do
        let(:create_response) {{
          status: 200,
          body: ""
        }}

        it 'creates new resource in dwolla' do
          expect(subject.save).to eq(true)
        end
      end

      context 'fail' do
        let(:create_response) { dwolla_helper.resource_create_error_response error_response }

        let(:error_response) {{
          code: "ValidationError",
          message: "Validation error(s) present. See embedded errors list for more details.",
          _embedded: {
            errors: [
              { code: "Invalid", message: "Invalid amount.", path: "/amount1/value" },
              { code: "Invalid", message: "Invalid amount.", path: "/amount2/value" }
            ]
          }
        }}

        it 'returns errors' do
          expect(subject.save).to eq(false)
          expect(subject.errors[:amount1]).to eq(['Invalid amount.'])
          expect(subject.errors[:amount2]).to eq(['Invalid amount.'])
        end
      end
    end

    context 'invalid attributes' do
      let(:attrs) {{}}

      it 'returns errors' do
        expect(subject.save).to eq(false)
        expect(subject.errors[:amount1]).to eq(["can't be blank", "is not a number"])
        expect(subject.errors[:amount2]).to eq(["can't be blank", "is not a number"])
      end
    end
  end
end
