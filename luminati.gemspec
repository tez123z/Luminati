Gem::Specification.new do |s|
  s.specification_version     = 2 if s.respond_to? :specification_version=
  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.5") if s.respond_to? :required_rubygems_version=

  s.name = 'luminati'
  s.version = '0.0.2'

  s.homepage      =   "https://github.com/Agiley/Luminati"
  s.email         =   "sebastian@agiley.se"
  s.authors       =   ["Sebastian Johnsson"]
  s.description   =   "Ruby-wrapper for communicating with the Luminati.io-network."
  s.summary       =   "Ruby-wrapper for communicating with the Luminati.io-network."

  s.add_dependency "faraday",             ">= 0.9"

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'mocha'

  # = MANIFEST =
 s.files = %w[
 Gemfile
 Gemfile.lock
 LICENSE
 README.md
 Rakefile
 lib/luminati.rb
 lib/luminati/client.rb
 lib/luminati/errors.rb
 luminati.gemspec
 spec/spec_helper.rb
 ]
 # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ %r{^spec/*/.+\.rb} }
end

