#$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
#require 'aws_resource'

require 'rubygems'
require 'bundler/setup'

require 'rspec'
require 'pry'

if ENV['COVERAGE']
  require 'simplecov'
  SimpleCov.formatter = SimpleCov::Formatter::HTMLFormatter
  SimpleCov.start do
    add_filter '.bundle/'
    add_filter 'spec'
  end
end

require 'aws_resource'

path = Pathname.new(Dir.pwd)
Dir[path.join('spec/support/**/*.rb')].each { |f| require f }

Dir.mkdir('log') unless Dir.exist?('log')

AwsResource.configure do |conf|
  conf.logger = Logger.new('log/test.log').tap do |l|
    l.level = Logger::DEBUG
  end
end

RSpec.configure do |config|
  config.order = 'random'
end
