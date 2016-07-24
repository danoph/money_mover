require 'spec_helper'

describe MoneyMover::Dwolla::Config do
  let(:api_endpoint) { double 'api endpoint' }

  let(:attrs) {{
    api_endpoint: api_endpoint
  }}

  subject { described_class.new(attrs) }

  describe '#api_endpoint' do
    it 'returns api endpoint' do
      expect(subject.api_endpoint).to eq(api_endpoint)
    end

    context 'not setting api endpoint' do
      let(:attrs) {{}}

      it 'returns api endpoint' do
        expect(subject.api_endpoint).to eq("https://api-uat.dwolla.com")
      end
    end
  end
end
