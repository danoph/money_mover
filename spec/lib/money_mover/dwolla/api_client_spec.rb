require 'spec_helper'

describe MoneyMover::Dwolla::ApiClient do
  let(:url) { double 'url' }
  let(:request_headers) { double 'request headers' }
  let(:request_params) { double 'request params', to_json: request_params_json }
  let(:request_params_json) { double 'request params json' }

  let(:response) { double 'response' }

  let(:request_headers) {{
    content_type: :json,
    accept: 'application/vnd.dwolla.v1.hal+json',
    Authorization: "Bearer #{access_token}"
  }}

  let(:request_headers_without_token) {{
    content_type: :json,
    accept: 'application/vnd.dwolla.v1.hal+json'
  }}

  let(:access_token) { 'X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak' }
  let(:api_endpoint) { double 'api endpoint' }

  let(:config) { double 'config', api_endpoint: api_endpoint }

  let(:full_url) { [ config.api_endpoint, url ].join '/' }

  subject { described_class.new(config) }

  describe '#post' do
    context 'with access token' do
      it 'calls endpoint with correct token' do
        expect(RestClient).to receive(:post).with(full_url, request_params_json, request_headers) { response }
        expect(subject.post(url, request_params, access_token)).to eq(response)
      end
    end

    context 'without access token' do
      it 'calls endpoint without access token' do
        expect(RestClient).to receive(:post).with(full_url, request_params_json, request_headers_without_token) { response }
        expect(subject.post(url, request_params)).to eq(response)
      end
    end
  end

  describe '#get' do
    context 'with access token' do
      it 'calls endpoint with correct token' do
        expect(RestClient).to receive(:get).with(full_url, request_headers) { response }
        expect(subject.get(url, access_token)).to eq(response)
      end
    end

    context 'without access token' do
      it 'calls endpoint without access token' do
        expect(RestClient).to receive(:get).with(full_url, request_headers_without_token) { response }
        expect(subject.get(url)).to eq(response)
      end
    end
  end
end
