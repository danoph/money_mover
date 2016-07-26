require 'active_support/core_ext/hash'
#require 'active_support/hash_with_indifferent_access'

require 'faraday'
require 'faraday_middleware'
require 'active_model'

require 'money_mover/version'
require 'money_mover/standalone_errors'

# dwolla
require 'money_mover/dwolla'

module MoneyMover; end

