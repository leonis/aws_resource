# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'aws_resource/version'

Gem::Specification.new do |spec|
  spec.name          = 'aws_resource'
  spec.version       = AwsResource::VERSION
  spec.authors       = ['Daisuke Hirakiuchi']
  spec.email         = ['devops@leonisand.co']

  spec.summary       = %q(a wrapper library to manipulate aws resource as Object.)
  spec.description   = %q(AwsResource is a aws-sdk wrapper library to manipulate aws resources as Object.)
  spec.homepage      = 'https://github.com/leonis/aws_resource'
  spec.licenses      = 'MIT'

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    fail 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.3'
  spec.add_development_dependency 'simplecov', '~> 0.10'
  spec.add_development_dependency 'pry-byebug', '~> 3.3'

  spec.add_dependency 'aws-sdk', '~> 2'
  spec.add_dependency 'activesupport', '~> 4.2'
end
