require 'spec_helper'

describe MoneyMover::Dwolla::ErrorHandler do
  subject { described_class.new(server_error) }

  describe '#errors' do
    context 'no embedded errors' do
      let(:server_error) {{
          code: "DuplicateResource",
          message: "Bank already exists: id=442efd3e-3f70-4cb1-a393-593dca3464b4",
          _embedded: nil
      }}

      it 'sets error correctly' do
        expect(subject.errors[:base]).to eq(["Bank already exists: id=442efd3e-3f70-4cb1-a393-593dca3464b4"])
      end
    end

    context 'json pointer path is /routingNumber' do
      let(:server_error) {{
        code: "ValidationError",
        message: "Validation error(s) present. See embedded errors list for more details.",
        _embedded: {
          errors: [
            {
              :code=>"Invalid",
              :message=>"Invalid parameter.",
              :path=>"/routingNumber"
            }
          ]
        }
      }}

      it 'sets error correctly' do
        expect(subject.errors[:routingNumber]).to eq(["Invalid parameter."])
      end
    end

    context 'json pointer path is /amount2/value' do
      let(:server_error) {{
        code: "ValidationError",
        message: "Validation error(s) present. See embedded errors list for more details.",
        _embedded: {
          errors: [
            {
              code: "Invalid",
              message: "Invalid amount.",
              path: "/amount2/value"
            }
          ]
        }
      }}

      it 'sets error correctly' do
        expect(subject.errors[:amount2]).to eq(["Invalid amount."])
      end
    end

    context 'json pointer path is empty' do
      let(:server_error) {{
        code: "ValidationError",
        message: "Validation error(s) present. See embedded errors list for more details.",
        _embedded: {
          errors: [
            {
              code: "Invalid",
              message: "Invalid amount."
            }
          ]
        }
      }}

      it 'sets error correctly' do
        expect(subject.errors[:base]).to eq(["Invalid amount."])
      end
    end
  end
end
