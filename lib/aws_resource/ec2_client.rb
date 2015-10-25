module AwsResource
  class Ec2Client < BaseClient
    include Enumerable

    def initialize(options = {})
      @client = ::Aws::EC2::Client.new(options)
      @options = {}
    end

    def with_params(options = {})
      dup.tap do |m|
        m.instance_variable_set(:@options, options)
      end
    end

    def each(options = {})
      iter = instance_iterator(options)

      return ResourceEnumerator.new(iter) unless block_given?

      loop { yield(iter.next) }
    end

    def exist?(instance_id)
      with_params(
        instance_ids: [instance_id]
      ).any?
    rescue ::Aws::EC2::Errors::InvalidInstanceIdNotFound => e
      logger.debug e
      false
    rescue ::Aws::EC2::Errors::InvalidInstanceIDMalformed => e
      logger.debug e
      false
    end

    private

    def instance_iterator(options)
      opts = (@options ? @options.merge(options) : options)

      AwsResource::Iterator::SimpleIterator.new(
        @client, :describe_instances, opts, &extract_instances
      )
    end

    def extract_instances
      proc do |result|
        values = []
        result.each_page do |page|
          page.reservations.each do |reservation|
            values.concat(
              reservation.instances.map { |attrs| Ec2.new(attrs) }
            )
          end
        end

        values
      end
    end
  end
end
