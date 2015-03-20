$LOAD_PATH << "." unless $LOAD_PATH.include?(".")

begin
  require "rubygems"
  require "bundler"

  if Gem::Version.new(Bundler::VERSION) <= Gem::Version.new("0.9.5")
    raise RuntimeError, "Your bundler version is too old." +
     "Run `gem install bundler` to upgrade."
  end

  # Set up load paths for all bundled gems
  Bundler.setup
rescue Bundler::GemNotFound
  raise RuntimeError, "Bundler couldn't find some gems." +
    "Did you run \`bundlee install\`?"
end

#require "active_record"
Bundler.require

require File.expand_path('../../lib/luminati', __FILE__)

RSpec.configure do |config|
  config.mock_with :mocha
end

CREDENTIALS = YAML.load_file(File.join(File.dirname(__FILE__), "/support/credentials.yml"))