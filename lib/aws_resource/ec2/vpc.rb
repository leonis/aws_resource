module AwsResource
  module Ec2
    class Vpc < ::AwsResource::Base
      class << self
        include Enumerable

        def with_params(options)
          dup.tap do |m|
            m.instance_variable_set(:@options, options.dup)
          end
        end

        def each(options = {})
          iter = instance_iterator(options)
          return ResourceEnumerator.new(iter) unless block_given?

          loop { yield(iter.next) }
        end

        private

        def client
          @client ||= ::Aws::EC2::Client.new
        end

        def instance_iterator(options)
          opts = (@options ? @options.merge(options) : options)

          AwsResource::Iterator::SimpleIterator.new(
            client, :describe_vpcs, opts, &extract_instances
          )
        end

        def extract_instances
          proc do |result|
            result.vpcs.map { |attrs| new(attrs) }
          end
        end
      end
    end
  end
end
