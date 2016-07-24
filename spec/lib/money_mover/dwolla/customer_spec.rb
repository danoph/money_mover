require 'spec_helper'

describe MoneyMover::Dwolla::Customer do
  describe '.find' do
    subject { described_class }

    let(:new_customer) { double 'new customer' }
    let(:id) { double 'id' }

    before do
      allow(MoneyMover::Dwolla::ApiRequest).to receive(:new).with(url: customer_url, access_token: dwolla_helper.access_token) { response }
      allow(subject).to receive(:new).with(parsed_json) { new_customer }
    end

    let(:customer_url) { [ "customers", id ].join '/' }

    let(:response) { double 'response', success?: success?, parsed_json: parsed_json }
    let(:parsed_json) {{
      firstName: 'first Name',
      lastName: 'last Name',
      email: 'email@example.com',
      ipAddress: 'ip Address'
    }}

    context 'success' do
      let(:success?) { true }

      it 'returns parsed json response' do
        expect(subject.find(id)).to eq(new_customer)
      end
    end

    context 'fail' do
      let(:success?) { false }

      it 'raises error' do
        expect{ subject.find(id) }.to raise_error('Customer Not Found')
      end
    end
  end
end
