require 'spec_helper'

describe MoneyMover::Dwolla::Transfer do
  let(:funding_source_token) { 'funding_source_token' }
  let(:destination_source_token) { 'destination_source_token' }
  let(:amount) { '12.45' }
  let(:metadata) { { ach_tranfer_id: 123 } }

  let(:dwolla_errors) { [ ['key1', 'error1'], ['key2', 'error2'] ] }
  let(:dwolla_response) { double 'dwolla response', success?: transfer_success?, resource_location: resource_location, resource_id: resource_id, errors: dwolla_errors }
  let(:api_url) { 'https:://api/url' }
  let(:dwolla_client) { double 'dwolla client', post: dwolla_response, api_url: api_url}

  let(:resource_location) { double 'resource location' }
  let(:resource_id) { double 'resource id' }

  let(:transfer_success?) { true }

  let(:attrs) {{
    sender_funding_source_token: funding_source_token,
    destination_funding_source_token: destination_source_token,
    transfer_amount: amount,
    metadata: metadata
  }}

  subject { described_class.new(attrs) }

  before do
    allow(MoneyMover::Dwolla::AccountClient).to receive(:new) { dwolla_client }
  end

  it { should validate_presence_of(:sender_funding_source_token) }
  it { should validate_presence_of(:destination_funding_source_token) }
  it { should validate_presence_of(:transfer_amount) }

  describe '#save' do
    let(:transfer_success?) { true }

    let(:transfer_params) {
      {
        _links: {
          destination: {
            href: "#{api_url}/funding-sources/#{destination_source_token}"
          },
          source: {
            href: "#{api_url}/funding-sources/#{funding_source_token}"
          }
        },
        amount: {
          value: amount.to_s,
          currency: "USD"
        },
        metadata: metadata
      }
    }

    context 'success' do
      it 'returns true and sets resource_location and id' do
        expect(dwolla_client).to receive(:post).with("/transfers", transfer_params)

        expect(subject.save).to eq(true)

        expect(subject.errors).to be_empty
        expect(subject.resource_location).to eq(resource_location)
        expect(subject.id).to eq(resource_id)
      end
    end

    context 'validations fail' do
      let(:funding_source_token) { nil }
      let(:destination_source_token) { nil }
      let(:amount) { nil }

      it 'does not attempt to create transfer and returns false with errors' do
        expect(dwolla_client).to_not receive(:post)

        expect(subject.save).to eq(false)
        expect(subject.errors.full_messages).to eq(["Sender funding source token can't be blank", "Destination funding source token can't be blank", "Transfer amount can't be blank"])
      end
    end

    context 'dwolla error' do
      let(:transfer_success?) { false }

      it 'returns false and has errors' do
        expect(dwolla_client).to receive(:post).with("/transfers", transfer_params)

        expect(subject.save).to eq(false)
        expect(subject.errors[:key1]).to eq(['error1'])
        expect(subject.errors[:key2]).to eq(['error2'])
      end
    end
  end
end
