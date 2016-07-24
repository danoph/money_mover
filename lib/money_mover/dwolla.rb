require 'money_mover/dwolla/config'
require 'money_mover/dwolla/account_token_provider'
require 'money_mover/dwolla/api_client'
require 'money_mover/dwolla/api_request'
require 'money_mover/dwolla/api_resource'
require 'money_mover/dwolla/customer'
require 'money_mover/dwolla/document'
require 'money_mover/dwolla/funding_source'
require 'money_mover/dwolla/microdeposit_initiation'
require 'money_mover/dwolla/microdeposit_verification'
require 'money_mover/dwolla/transfer'
require 'money_mover/dwolla/unverified_customer'

module MoneyMover
  module Dwolla
    @account_token_provider = nil

    class << self
      attr_accessor :account_token_provider
    end
  end
end
