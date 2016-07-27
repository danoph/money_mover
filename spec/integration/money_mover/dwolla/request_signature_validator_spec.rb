require 'spec_helper'

describe MoneyMover::Dwolla::RequestSignatureValidator do
  let(:event_params) {
    {
      id: "177dd734-3ce1-4701-8f92-9e57386d20f2",
      resourceId: 'some-id',
      topic: "some_topic",
      timestamp: "2016-03-24T20:29:40.346Z",
      _links: {
        self: {href: "https://api-uat.dwolla.com/events/177dd734-3ce1-4701-8f92-9e57386d20f2"},
        account: {href: "https://api-uat.dwolla.com/accounts/0f6589ac-588d-4283-81fc-325cbaa33d54"},
        resource: {href: "https://api-uat.dwolla.com/funding-sources/something"},
        customer: {href:"https://api-uat.dwolla.com/customers/2b4af2fe-4d2c-4a5f-8f06-898449086b7b"}
      }
    }
  }

  let(:request_body) { double 'request body', string: request_body_string }
  let(:request_body_string) { Rack::Utils.build_nested_query event_params }

  subject { described_class.new request_body, request_headers  }

  describe '#valid?' do
    context 'request correctly signed' do
      let(:request_headers) { dwolla_helper.webhook_signed_header(event_params) }

      it 'returns true' do
        expect(subject.valid?).to eq(true)
      end
    end
  end

  context 'request NOT correctly signed' do
    let(:request_headers) { dwolla_helper.webhook_header }

    it 'rejects the request with a 401' do
      expect(subject.valid?).to eq(false)
      expect(subject.errors[:base]).to eq(['Request Signature Invalid'])
    end
  end

  context 'request DOES NOT have signature header' do
    let(:request_headers) {{}}

    it 'rejects the request with a 401' do
      expect(subject.valid?).to eq(false)
      expect(subject.errors[:base]).to eq(['Request Signature Invalid'])
    end
  end
end

