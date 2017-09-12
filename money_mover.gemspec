$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'money_mover/version'

Gem::Specification.new do |s|
  s.required_ruby_version = '>= 2.2.0'
  s.name        = 'money_mover'
  s.version     = MoneyMover::VERSION
  s.date        = '2016-07-21'
  s.summary     = "Money Mover"
  s.description = "Moves Money with ACH integrations (dwolla, stripe)"
  s.authors     = ["Daniel Errante"]
  s.email       = 'danoph@gmail.com'
  s.files       = ["lib/money_mover.rb"]
  s.homepage    = 'https://github.com/danoph/money_mover'
  s.license     = 'MIT'

  s.add_dependency 'faraday', '~> 0.13.1'
  s.add_dependency 'faraday_middleware', '~> 0.12'
  s.add_dependency 'activemodel', '~> 5.0'
  s.add_dependency 'activesupport', '~> 5.0'
  s.add_dependency 'rack', '>= 1.6', '< 2.1'

  s.add_development_dependency 'rake', '~> 11.2'
  s.add_development_dependency 'rspec', '~> 3.5'
  s.add_development_dependency 'webmock', '~> 2.1'
  s.add_development_dependency 'shoulda-matchers', '~> 3.1'
  s.add_development_dependency 'rack-test', '~> 0.6'

  s.files = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  #s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ['lib']
end
