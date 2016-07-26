require 'spec_helper'

describe MoneyMover::Dwolla::FundingSource do
  let(:customer_id) { double 'customer id' }

  let(:name) { 'some name' }
  let(:type) { 'checking' }
  let(:routingNumber) { 'routing number' }
  let(:accountNumber) { 'account number' }

  let(:attrs) {{
    name: name,
    type: type,
    routingNumber: routingNumber,
    accountNumber: accountNumber
  }}

  subject { described_class.new customer_id, attrs }

  let(:dwolla_client) { double 'dwolla client' }

  let(:dwolla_response) { double 'dwolla response', success?: save_success?, resource_location: resource_location, resource_id: resource_id, errors: dwolla_errors }
  let(:dwolla_errors) { [ ['key1', 'error1'], ['key2', 'error2'] ] }

  let(:resource_location) { double 'resource location' }
  let(:resource_id) { double 'resource id' }

  before do
    allow(MoneyMover::Dwolla::AccountClient).to receive(:new) { dwolla_client }
  end

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:type) }
  it { should validate_presence_of(:routingNumber) }
  it { should validate_presence_of(:accountNumber) }

  describe '#save' do
    let(:save_success?) { true }

    let(:create_params) {{
      name: name,
      type: type,
      routingNumber: routingNumber,
      accountNumber: accountNumber
    }}

    let(:create_endpoint) { "/customers/#{customer_id}/funding-sources" }

    context 'success' do
      let(:save_success?) { true }

      it 'returns true and sets resource_location and id' do
        expect(dwolla_client).to receive(:post).with(create_endpoint, create_params) { dwolla_response }

        expect(subject.save).to eq(true)

        expect(subject.errors).to be_empty
        expect(subject.resource_location).to eq(resource_location)
        expect(subject.id).to eq(resource_id)
      end
    end

    context 'validations fail' do
      let(:name) { nil }
      let(:type) { nil }
      let(:routingNumber) { nil }
      let(:accountNumber) { nil }

      it 'does not attempt to create transfer and returns false with errors' do
        expect(dwolla_client).to_not receive(:post)

        expect(subject.save).to eq(false)

        expect(subject.errors[:name]).to eq(["can't be blank"])
        expect(subject.errors[:type]).to eq(["can't be blank", "is not included in the list"])
        expect(subject.errors[:routingNumber]).to eq(["can't be blank"])
        expect(subject.errors[:accountNumber]).to eq(["can't be blank"])
      end
    end

    context 'dwolla error' do
      let(:save_success?) { false }

      it 'returns false and has errors' do
        expect(dwolla_client).to receive(:post).with(create_endpoint, create_params) { dwolla_response }

        expect(subject.save).to eq(false)

        expect(subject.errors[:key1]).to eq(['error1'])
        expect(subject.errors[:key2]).to eq(['error2'])
      end
    end
  end
end
