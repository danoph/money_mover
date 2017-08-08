require 'spec_helper'

describe MoneyMover::Dwolla::ApplicationClient do
  let(:expected_response) { double 'expected response' }
  let(:server_request) { double 'server request' }

  let(:url_provider) { double 'url provider', api_url: api_url }
  let(:api_url) { double' api url' }

  subject { described_class.new }

  let(:token) { double 'account token' }
  let(:dwolla_token_provider) { double 'token provider', access_token: token }

  let(:api_connection) { double 'api connection', connection: faraday_connection }
  let(:faraday_connection) { double 'faraday connection' }

  before do
    allow(MoneyMover::Dwolla::ApiConnection).to receive(:new).with(token) { api_connection }
    allow(MoneyMover::Dwolla::ApplicationToken).to receive(:new) { dwolla_token_provider }
  end

  let(:url) { double 'url' }
  let(:params) { double 'params' }

  describe '#post' do
    let(:expected_response) { double 'expected response' }
    let(:server_request) { double 'server request', response: expected_response }

    before do
      allow(faraday_connection).to receive(:post).with(url, params) { server_request }
      allow(MoneyMover::Dwolla::ApiServerResponse).to receive(:new).with(server_request) { expected_response }
    end

    it 'returns success response' do
      expect(subject.post(url, params)).to eq(expected_response)
    end
  end

  describe '#delete' do
    before do
      allow(faraday_connection).to receive(:delete).with(url, params) { server_request }
      allow(MoneyMover::Dwolla::ApiServerResponse).to receive(:new).with(server_request) { expected_response }
    end

    it 'returns SuccessResponse' do
      expect(subject.delete(url, params)).to eq(expected_response)
    end
  end

  describe '#get' do
    before do
      allow(faraday_connection).to receive(:get).with(url, params) { server_request }
      allow(MoneyMover::Dwolla::ApiServerResponse).to receive(:new).with(server_request) { expected_response }
    end

    it 'returns response from token#get' do
      expect(subject.get(url, params)).to eq(expected_response)
    end
  end
end

describe MoneyMover::Dwolla::ApplicationClient do
  describe '#post' do
    let(:url) { '/customers' }

    let(:params) {{
      firstName: 'someone first name',
      lastName: 'someone last name',
      email: 'email@example.com',
      businessName: 'some company name',
      type: 'receive-only'
    }}

    before do
      dwolla_helper.stub_create_customer_request(params, create_response)
    end

    context 'success' do
      let(:create_response) { dwolla_helper.create_customer_success_response(customer_token) }
      let(:customer_token) { 'some-customer-token' }

      it 'returns success response' do
        response = subject.post(url, params)
        expect(response.resource_id).to eq(customer_token)
        expect(response.resource_location).to eq(dwolla_helper.customer_url(customer_token))
      end
    end

    context 'error' do
      let(:create_response) {
        dwolla_helper.error_response :code=>"ValidationError", :message=>"Validation error(s) present. See embedded errors list for more details.", :_embedded=>{:errors=>[{:code=>"Duplicate", :message=>"A customer with the specified email already exists.", :path=>"/email"}]}
      }

      it 'returns error response' do
        response = subject.post(url, params)
        expect(response.errors[:email]).to eq(['A customer with the specified email already exists.'])
      end
    end
  end
end
