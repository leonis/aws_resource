module AwsResource
  class Config
    include ActiveSupport::Configurable
    config_accessor :logger
  end
end
