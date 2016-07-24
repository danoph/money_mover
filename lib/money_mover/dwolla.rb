require 'money_mover/dwolla/config'
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
    @access_token = nil

    class << self
      attr_accessor :access_token
    end
  end
end
