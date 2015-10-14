# AwsResource

NOTE: under development yet.

AwsResource is a wrapper library to manipulate aws resources as Object.

- Easy iteration (no need to use token or marker.)
- Aws resources(like Ec2 instance, Vpc instance, Elb instance...) describe as a model class instance.
  - you can extend model class (AwsResource::Ec2, AwsResource::Vpc, etc), like below.

```
# Add stop method to stop the instance
class AwsResource::Ec2
  def stop(options = {})
    result = @client.stop_instances(
      options.merge(instance_ids: [instance_id])
    )

    result.stopping_instances.map { |attrs| Ec2.new(attrs) }
  end
end

# find some ec2 instances filtered by params
# and stop the instance if the instance is in the some_condigion.
client = AwsResource::Ec2Client.new
client.each_instances(params) do |instance|
  instance.stop if instance.some_condition?
end
```

NOTE: This gem looks like [aws-sdk-resource](https://github.com/aws/aws-sdk-ruby/tree/master/aws-sdk-resources)

## Current state

- EC2
  - [x] client
  - [x] model
- VPC
  - [x] client
  - [x] model
- ELB
  - [x] client
  - [x] model
- AutoScalingGroup
  - [x] client
  - [x] model

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aws_resource'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install aws_resource

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/leonis/aws_resource.

