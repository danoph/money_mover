require 'spec_helper'

describe MoneyMover::Dwolla::Customer do
  describe '.find' do
    subject { described_class }

    let(:new_customer) { double 'new customer' }
    let(:id) { double 'id' }

    let(:client) { double 'client' }

    before do
      allow(MoneyMover::Dwolla::ApiClient).to receive(:new) { client }
      allow(subject).to receive(:new).with(response_body) { new_customer }
    end

    let(:customer_url) { [ "customers", id ].join '/' }

    let(:response) { double 'response', code: response_code, body: response_body.to_json }
    let(:response_body) { '' }

    context 'success' do
      let(:response_code) { 200 }
      let(:response_body) {{
        firstName: 'first Name',
        lastName: 'last Name',
        email: 'email@example.com',
        ipAddress: 'ip Address'
      }}

      it 'returns parsed json response' do
        expect(client).to receive(:get).with(customer_url) { response }
        expect(subject.find(id)).to eq(new_customer)
      end
    end

    context 'fail' do
      let(:response_code) { 404 }

      it 'raises error' do
        expect(client).to receive(:get).with(customer_url) { response }
        expect{ subject.find(id) }.to raise_error('Customer Not Found')
      end
    end
  end
end
