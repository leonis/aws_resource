module AwsResource
  class Ec2Client < BaseClient
    def initialize(options = {})
      @client = ::Aws::EC2::Client.new(options)
    end

    def each_instances(options = {}, &block)
      result = @client.describe_instances(options)
      return [] if result.nil?

      instances = []
      result.each_page do |page|
        page.reservations.each do |reservation|
          reservation.instances.each do |attrs|
            ec2 = Ec2.new(attrs)
            instances << ec2
            block.call(ec2) if block
          end
        end
      end

      instances
    end
    alias_method :instances, :each_instances

    def exist?(instance_id)
      result = instances(instance_ids: [instance_id])
      result.any? && result.size == 1
    rescue ::Aws::EC2::Errors::InvalidInstanceIdNotFound => e
      logger.debug e
      false
    rescue ::Aws::EC2::Errors::InvalidInstanceIDMalformed => e
      logger.debug e
      false
    end
  end
end
