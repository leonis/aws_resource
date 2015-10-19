module AwsResource
  class AutoScalingClient < BaseClient
    def initialize(options = {})
      @client = ::Aws::AutoScaling::Client.new(options)
    end

    def each_auto_scaling_groups(options = {})
      token = nil
      groups = []

      loop do
        result = @client.describe_auto_scaling_groups(
          options.merge(next_token: token)
        )

        token = result.next_token

        result.auto_scaling_groups.each do |attrs|
          as = AutoScalingGroup.new(attrs, self)
          groups << as
          yield(as) if block_given?
        end

        fail StopIteration if token.nil?
      end

      groups
    end
    alias_method :auto_scaling_groups, :each_auto_scaling_groups

    def find_by_name(auto_scaling_group_name)
      auto_scaling_groups(
        auto_scaling_group_names: [auto_scaling_group_name]
      ).first
    rescue => e
      logger.warn e
      nil
    end

    def each_launch_configurations(options = {})
      token = nil
      configurations = []

      loop do
        result = @client.describe_launch_configurations(
          options.merge(next_token: token)
        )

        token = result.next_token

        result.launch_configurations.each do |attrs|
          configuration = LaunchConfiguration.new(attrs)
          configurations << configuration
          yield(configuration) if block_given?
        end

        fail StopIteration if token.nil?
      end

      configurations
    end
    alias_method :launch_configurations, :each_launch_configurations

    def find_launch_configuration_by_name(name)
      launch_configurations(
        launch_configuration_names: [name]
      ).first
    rescue => e
      logger.warn e
      nil
    end
  end
end
