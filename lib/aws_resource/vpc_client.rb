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
    alias_method :vpcs, :each_vpcs

    # Find vpc by vpc_id
    #
    # @param vpc_id [String] vpc_id
    # @return AwsResource::Vpc instance or nil
    def find_by_id(vpc_id)
      vpcs(vpc_ids: [vpc_id]).first
    rescue Aws::EC2::Errors::FilterLimitExceeded,
           Aws::EC2::Errors::InvalidVpcIDNotFound => e
      logger.warn e
      nil
    end

    # Find vpc by name
    #
    # @param vpc_name [String] vpc name
    # @return AwsResource::Vpc instance or nil
    def find_by_name(vpc_name)
      vpcs(
        filters: [
          { name: 'tag-key', values: ['Name'] },
          { name: 'tag-value', values: [vpc_name] }
        ]
      ).first
    rescue Aws::EC2::Errors::FilterLimitExceeded,
           Aws::EC2::Errors::InvalidVpcIDNotFound => e
      logger.warn e
      nil
    end
  end
end
