require 'spec_helper'

describe MoneyMover::Dwolla::MicroDepositInitiation do
  let(:response_errors) { { key1: 'Error1', key2: 'Error2' } }
  let(:ach_response) { double 'ach response', success?: response_success?, resource_location: resource_location, resource_id: resource_id, errors: response_errors}
  let(:resource_location) { double 'resource location' }
  let(:resource_id) { double 'resource id' }
  let(:ach_client) { double 'Dwolla Client', post: ach_response }

  let(:funding_source_id) { 'some_funding_source_id_token' }

  subject { described_class.new(funding_source_id: funding_source_id) }

  before do
    allow(MoneyMover::Dwolla::AccountClient).to receive(:new) { ach_client }
  end

  context 'success' do
    let(:response_success?) { true }

    it 'posts to ach provider and returns true' do
      expect(ach_client).to receive(:post).with("/funding-sources/#{funding_source_id}/micro-deposits", {})
      expect(subject.save).to eq(true)
    end
  end

  context 'ach failure' do
    let(:response_success?) { false }

    it 'posts to ach provider and returns false and has errors' do
      expect(ach_client).to receive(:post).with("/funding-sources/#{funding_source_id}/micro-deposits", {})
      expect(subject.save).to eq(false)
      expect(subject.errors.to_a).to eq(["Key1 Error1", "Key2 Error2"])
    end
  end
end
