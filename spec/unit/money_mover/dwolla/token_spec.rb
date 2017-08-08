require 'spec_helper'

describe MoneyMover::Dwolla::ApplicationToken do
  let(:ach_config) { double 'ach config', api_key: ach_config_api_key, api_secret_key: ach_config_api_secret_key, environment: ach_config_environment, account_token_provider: account_token_provider }
  let(:ach_config_api_key) { double 'ach config api key' }
  let(:ach_config_api_secret_key) { double 'ach config api secret' }
  let(:ach_config_environment) { double 'ach config environment' }
  let(:account_token_provider) { double 'account token provider', access_token: account_access_token }
  let(:account_access_token) { double 'account access token' }

  let(:attrs) {{}}

  subject { described_class.new attrs, ach_config }

  describe '#access_token' do
    it 'returns account token from account token provider' do
      expect(subject.access_token).to eq(account_access_token)
    end
  end
end

# INTEGRATION TEST
describe MoneyMover::Dwolla::ApplicationToken do
  let(:refresh_token_request_params) {{
    "client_id": "JCGQXLrlfuOqdUYdTcLz3rBiCZQDRvdWIUPkw++GMuGhkem9Bo",
    "client_secret": "g7QLwvO37aN2HoKx1amekWi8a2g7AIuPbD5C/JSLqXIcDOxfTr",
    "grant_type": "client_credentials"
  }}

  let(:account_id) { "7da912eb-5976-4e5c-b5ab-a5df35ac661b" }
  let(:new_access_token) { "oNGSeXqucdVxTLAwSRNc1WjG5BTHWNS5z7hccJGUTGvCXusmbC" }

  let(:refresh_token_success_response) {{
    "_links": {
      "account": {
        "href":"https://api-uat.dwolla.com/accounts/#{account_id}"
      }
    },
    "access_token": new_access_token,
    "expires_in":3600,
    "refresh_expires_in":5184000,
    "token_type":"bearer",
    "scope":"accountinfofull|contacts|transactions|balance|send|request|funding|manageaccount|scheduled|email|managecustomers",
    "account_id": account_id
  }}

  describe '#request_new_token!' do
    let(:token_response) { refresh_token_success_response }

    before do
      dwolla_helper.stub_refresh_token_request(token_response)
    end

    context 'success' do
      it 'updates token' do
        new_token = subject.request_new_token!

        expect(new_token.account_id).to eq(account_id)
        expect(new_token.expires_in).to eq(3600)
        expect(new_token.access_token).to eq(new_access_token)
      end
    end
  end
end
