require 'spec_helper'

describe MoneyMover::Dwolla::ApiRequest do
  let(:url) { 'some-url' }

  before do
    dwolla_helper.stub_get_request url, response
  end

  subject { described_class.new(url) }

  describe '#success?' do
    context 'success' do
      let(:response_body) {{
        id: 'something',
        firstName: 'first name',
        lastName: 'last name',
        email: 'email',
        ipAddress: 'ip',
      }}

      let(:response) {{
        status: 200,
        body: response_body.to_json
      }}

      it 'returns true' do
        expect(subject.success?).to eq(true)
        expect(subject.errors).to eq({})
      end
    end

    context 'failure' do
      let(:response_body) {{
        code: 'Something',
        message: 'Customer not found.'
      }}

      let(:response) {{
        status: 404,
        body: response_body.to_json
      }}

      it 'returns false' do
        expect(subject.success?).to eq(false)
        expect(subject.errors[:base]).to eq(['Customer not found.'])
      end
    end
  end
end
