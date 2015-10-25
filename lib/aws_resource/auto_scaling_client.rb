module AwsResource
  class AutoScalingClient < BaseClient
    include Enumerable

    def initialize(options = {})
      @client = ::Aws::AutoScaling::Client.new(options)
      @options = {}
    end

    def with_params(options = {})
      dup.tap do |m|
        m.instance_variable_set(:@options, options)
      end
    end

    def each(options = {})
      iter = groups_iterator(options)
      return resource_enumerator(iter) unless block_given?

      loop { yield(iter.next) }
    end

    def find_by_name(auto_scaling_group_name)
      auto_scaling_groups(
        auto_scaling_group_names: [auto_scaling_group_name]
      ).first
    rescue => e
      logger.warn e
      nil
    end

    def each_launch_configurations(options = {})
      iter = configurations_iterator(options)
      return resource_enumerator(iter) unless block_given?

      loop { yield(iter.next) }
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

    private

    def groups_iterator(options)
      opts = (@options ? @options.merge(options) : options)

      AwsResource::Iterator::TokenIterator.new(
        @client, :describe_auto_scaling_groups, opts, &extract_groups
      )
    end

    def configurations_iterator(options)
      opts = (@options ? @options.merge(options) : options)

      AwsResource::Iterator::SimpleIterator.new(
        @client, :describe_launch_configurations, opts, &extract_configurations
      )
    end

    def extract_groups
      proc do |result|
        result.auto_scaling_groups.map do |attrs|
          AutoScalingGroup.new(attrs, self)
        end
      end
    end

    def extract_configurations
      proc do |result|
        result.launch_configurations.map do |attrs|
          LaunchConfiguration.new(attrs)
        end
      end
    end
  end
end
