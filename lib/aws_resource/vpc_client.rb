module AwsResource
  class VpcClient < BaseClient
    def initialize(options = {})
      @client = ::Aws::EC2::Client.new(options)
    end

    def each_vpcs(options = {}, &block)
      result = @client.describe_vpcs(options)
      return [] if result.nil?

      vpcs = []
      result.vpcs.each do |attrs|
        vpc = Vpc.new(attrs)
        vpcs << vpc
        block.call(vpc) if block
      end

      vpcs
    end
  end
end
