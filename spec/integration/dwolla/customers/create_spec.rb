require 'spec_helper'

describe MoneyMover::Dwolla::Customer do
  let(:attrs) {{}}

  subject { described_class.new(attrs) }

  describe '#save' do
    it 'creates new customer in dwolla' do
      expect(subject.save).to eq(true)
    end
  end
end
