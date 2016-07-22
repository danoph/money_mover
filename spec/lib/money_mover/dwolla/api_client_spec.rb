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

  let(:access_token) { 'X7JyEzy6F85MeDZERFE2CgiLbm9TXIbQNmr16cCfI6y1CtPrak' }
  let(:api_endpoint) { double 'api endpoint' }

  let(:config) { double 'config', api_endpoint: api_endpoint, access_token: access_token }

  let(:full_url) { [ config.api_endpoint, url ].join '/' }

  subject { described_class.new(config) }

  describe '#post' do
    it 'calls endpoint with correct token' do
      expect(RestClient).to receive(:post).with(full_url, request_params_json, request_headers) { response }
      expect(subject.post(url, request_params)).to eq(response)
    end
  end

  describe '#get' do
    it 'calls endpoint with correct token' do
      expect(RestClient).to receive(:get).with(full_url, request_headers) { response }
      expect(subject.get(url)).to eq(response)
    end
  end
end
