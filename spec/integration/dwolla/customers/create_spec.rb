require 'spec_helper'

describe MoneyMover::Dwolla::Customer do
  describe '#save' do
    it 'creates new customer in dwolla' do
      expect(subject.save).to eq(true)
    end
  end
end
