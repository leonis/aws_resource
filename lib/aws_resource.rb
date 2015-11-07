require 'aws_resource/version'

require 'logger'

require 'aws-sdk'
require 'active_support'

require 'aws_resource/config'
require 'aws_resource/null_logger'

require 'aws_resource/iterator/simple_iterator'
require 'aws_resource/iterator/token_iterator'
require 'aws_resource/iterator/marker_iterator'

require 'aws_resource/enumerator'

require 'aws_resource/concerns/enumerable'

require 'aws_resource/base'
require 'aws_resource/ec2/instance'
require 'aws_resource/ec2/vpc'
#require 'aws_resource/auto_scaling/group'
#require 'aws_resource/ec2'
#require 'aws_resource/vpc'
#require 'aws_resource/elb'
#require 'aws_resource/auto_scaling_group'

#require 'aws_resource/base_client'
#require 'aws_resource/ec2_client'
#require 'aws_resource/vpc_client'
#require 'aws_resource/elb_client'
#require 'aws_resource/auto_scaling_client'

module AwsResource
  class << self
    include ActiveSupport::Configurable
    attr_accessor :logger

    def configure
      yield(config)
    end

    def config
      @config ||= AwsResource::Config.new
    end

    def logger
      config.logger || AwsResource::NullLogger.new
    end
  end
end
