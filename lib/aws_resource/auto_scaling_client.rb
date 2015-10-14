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
          as = AutoScalingGroup.new(attrs)
          groups << as
          yield(as) if block_given?
        end

        fail StopIteration if token.nil?
      end

      groups
    end
    alias_method :auto_scaling_groups, :each_auto_scaling_groups
  end
end
