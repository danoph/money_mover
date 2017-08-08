require 'spec_helper'

describe MoneyMover::Dwolla::RootAccount do
  let(:client) { double 'dwolla account client' }
  let(:account_token) { "account_token_value" }
  let(:bank_funding_source_token) { "bank_funding_source_token_value" }

  let(:account_response) { double 'account response', success?: account_success?, body: account_response_body }
  let(:account_success?) { true }

  let(:account_response_body) do
    {
      :_links=>{
        :account=>{
          :href=>"https://api-uat.dwolla.com/accounts/#{account_token}"
        },
        :customers=>{:href=>"https://api-uat.dwolla.com/customers"}
      }
    }
  end

  let(:funding_response) { double 'funding response', body: funding_response_body }

  let(:funding_response_body) do
    {
      :_links=>{
        :self=>{
          :href=>"https://api-uat.dwolla.com/accounts/#{account_token}/funding-sources"
        }
      },
      :_embedded=>{
        :"funding-sources"=>[
          {
            :_links=>{
              :self=>{
                :href=>"https://api-uat.dwolla.com/funding-sources/#{bank_funding_source_token}"
              },
              :account=>{
                :href=>"https://api-uat.dwolla.com/accounts/#{account_token}"
              }
            },
            :id=>bank_funding_source_token,
            :status=>"verified",
            :type=>"bank",
            :name=>"Superhero Savings Bank",
            :created=>'2016-03-08 17:43:43 UTC'
          },
          {
            :_links=>{
              :self=>{
                :href=>"https://api-uat.dwolla.com/funding-sources/90fa0eff-8ea0-4cab-89eb-72a1f5d93c13"
              },
              :account=>{
                :href=>"https://api-uat.dwolla.com/accounts/#{account_token}"
              },
              :"with-available-balance"=>{
                :href=>"https://api-uat.dwolla.com/funding-sources/90fa0eff-8ea0-4cab-89eb-72a1f5d93c13"
              }
            },
            :id=>"90fa0eff-8ea0-4cab-89eb-72a1f5d93c13",
            :status=>"verified",
            :type=>"balance",
            :name=>"Balance",
            :created=>'2016-03-08 17:43:42 UTC'
          }
        ]
      }
    }
  end

  before do
    allow(MoneyMover::Dwolla::ApplicationClient).to receive(:new) { client }
    allow(client).to receive(:get).with('/') { account_response }
    allow(client).to receive(:get).with("/accounts/#{account_token}/funding-sources") { funding_response }
  end

  describe '.fetch' do
    subject { described_class }

    it 'returns expected token hash' do
      account = subject.fetch
      expect(account.account_resource_id).to eq(account_token)
      expect(account.bank_account_funding_source.id).to eq(bank_funding_source_token)
    end
  end
end
