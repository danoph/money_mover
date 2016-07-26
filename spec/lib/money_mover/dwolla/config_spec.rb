require 'spec_helper'

describe MoneyMover::Dwolla::Config do
  let(:webhook_secret_key) { double 'webhook secret key' }
  let(:webhook_callback_url) { double 'webhook callback url' }
  let(:api_key) { double 'api key' }
  let(:api_secret_key) { double 'api secret key' }
  let(:environment) { double 'environment' }
  let(:ach_provider_config) { double 'configatron ach provider store', webhook_secret_key: webhook_secret_key, webhook_callback_url: webhook_callback_url, api_key: api_key, api_secret_key: api_secret_key, environment: environment }

  subject { described_class.new(ach_provider_config) }

  it 'returns expected values' do
    expect(subject.webhook_secret_key).to eq(webhook_secret_key)
    expect(subject.webhook_callback_url).to eq(webhook_callback_url)
    expect(subject.api_key).to eq(api_key)
    expect(subject.api_secret_key).to eq(api_secret_key)
    expect(subject.environment).to eq(environment)
  end
end
