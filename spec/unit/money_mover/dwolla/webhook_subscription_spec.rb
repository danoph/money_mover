require 'spec_helper'

describe MoneyMover::Dwolla::WebhookSubscription do
  let(:dwolla_client) { double 'dwolla client' }
  let(:response_body) { nil }

  before do
    allow(MoneyMover::Dwolla::ApplicationClient).to receive(:new) { dwolla_client }
  end

  describe '.all' do
    let(:id1) { 'tokenizedid1' }
    let(:id2) { 'tokenizedid2' }
    let(:response_body) { { _embedded: { :'webhook-subscriptions' => [ sub1, sub2 ] } } }
    let(:sub1) { { id: 'sub1', url: 'url1' } }
    let(:sub2) { { id: 'sub2', url: 'url2' } }

    let(:dwolla_response) { double 'dwolla response', body: response_body }

    subject { described_class }

    before do
      allow(dwolla_client).to receive(:get).with('/webhook-subscriptions') { dwolla_response }
    end

    it 'returns expected ids' do
      subscriptions = subject.all

      expect(subscriptions.length).to eq(2)
      expect(subscriptions[0].id).to eq(sub1[:id])
      expect(subscriptions[0].url).to eq(sub1[:url])
      expect(subscriptions[1].id).to eq(sub2[:id])
      expect(subscriptions[1].url).to eq(sub2[:url])
    end
  end

  describe '#save' do
    let(:callback_url) { double 'callback url' }
    let(:webhook_secret_key) { double 'webhook secret key' }

    let(:resource_location) { double 'resource location' }
    let(:resource_id) { double 'resource id' }
    let(:response_errors) { [] }
    let(:dwolla_response) { double 'dwolla response', success?: save_success?, errors: response_errors, resource_location: resource_location, resource_id: resource_id }

    subject { described_class.new(url: callback_url, secret: webhook_secret_key) }

    before do
      allow(dwolla_client).to receive(:post).with('/webhook-subscriptions', { url: callback_url, secret: webhook_secret_key }) { dwolla_response }
    end

    context 'success' do
      let(:save_success?) { true }

      it 'sets resource properties and returns true' do
        expect(subject.save).to eq(true)
        expect(subject.id).to eq(resource_id)
        expect(subject.resource_location).to eq(resource_location)
      end
    end

    context 'failure' do
      let(:save_success?) { false }
      let(:response_errors) { [ [:base, 'Error1'], [:base, 'Error2'] ] }

      it 'returns false and has errors' do
        expect(subject.save).to eq(false)
        expect(subject.errors[:base]).to eq(['Error1', 'Error2'])
      end
    end
  end

  describe '#destroy' do
    let(:subscription_id) { 'dwollatokenid' }
    let(:response_errors) { [] }
    let(:dwolla_response) { double 'dwolla response', success?: delete_success?, errors: response_errors }

    subject { described_class.new(id: subscription_id) }

    before do
      allow(dwolla_client).to receive(:delete).with("/webhook-subscriptions/#{subscription_id}") { dwolla_response }
    end

    context 'success' do
      let(:delete_success?) { true }

      it 'returns true' do
        expect(subject.destroy).to eq(true)
      end
    end

    context 'failure' do
      let(:delete_success?) { false }
      let(:response_errors) { [ [:base, 'Error1'], [:base, 'Error2'] ] }

      it 'returns false and has errors' do
        expect(subject.destroy).to eq(false)
        expect(subject.errors[:base]).to eq(['Error1', 'Error2'])
      end
    end
  end
end

# INTEGRATION BLACK BOX TEST - making sure that application token is used instead of account token
describe MoneyMover::Dwolla::WebhookSubscription do
  describe '.all' do
    let(:id1) { 'tokenizedid1' }
    let(:id2) { 'tokenizedid2' }
    let(:webhooks_response) { { _embedded: { :'webhook-subscriptions' => [ sub1, sub2 ] } } }
    let(:sub1) { { id: 'sub1', url: 'url1' } }
    let(:sub2) { { id: 'sub2', url: 'url2' } }

    let(:dwolla_response) { double 'dwolla response', body: response_body }

    subject { described_class }

    before do
      dwolla_helper.stub_get_webhook_subscriptions_request(webhooks_response)
    end

    it 'returns expected ids' do
      subscriptions = subject.all

      expect(subscriptions.length).to eq(2)
      expect(subscriptions[0].id).to eq(sub1[:id])
      expect(subscriptions[0].url).to eq(sub1[:url])
      expect(subscriptions[1].id).to eq(sub2[:id])
      expect(subscriptions[1].url).to eq(sub2[:url])
    end
  end

  describe '#save' do
    let(:callback_url) { "https://callbackurl.com" }
    let(:webhook_secret_key) { "some-secret-key" }

    let(:create_params) {{
      url: callback_url,
      secret: webhook_secret_key
    }}

    let(:webhook_token) { 'some-webhook-subscription-token' }
    let(:webhook_location) { dwolla_helper.webhook_subscription_url(webhook_token) }

    subject { described_class.new(url: callback_url, secret: webhook_secret_key) }

    before do
      dwolla_helper.stub_create_webhook_subscription_request(create_params, create_response)
    end

    context 'success' do
      let(:create_response) { dwolla_helper.create_webhook_success_response(webhook_token) }

      it 'sets resource properties and returns true' do
        expect(subject.save).to eq(true)
        expect(subject.id).to eq(webhook_token)
        expect(subject.resource_location).to eq(webhook_location)
      end
    end

    context 'failure' do
      let(:create_response) { dwolla_helper.error_response({ message: 'some error' }) }

      it 'returns false and has errors' do
        expect(subject.save).to eq(false)
        expect(subject.errors[:base]).to eq(['some error'])
      end
    end
  end

  describe '#destroy' do
    let(:subscription_id) { 'some-subscription-id' }

    subject { described_class.new(id: subscription_id) }

    before do
      dwolla_helper.stub_delete_webhook_subscription_request(subscription_id, delete_response)
    end

    context 'success' do
      let(:delete_response) { dwolla_helper.resource_deleted_response }

      it 'returns true' do
        expect(subject.destroy).to eq(true)
      end
    end

    context 'failure' do
      let(:delete_response) { dwolla_helper.error_response({ message: 'some error' }) }

      it 'returns false and has errors' do
        expect(subject.destroy).to eq(false)
        expect(subject.errors[:base]).to eq(['some error'])
      end
    end
  end
end
