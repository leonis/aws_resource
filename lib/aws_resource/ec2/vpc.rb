module AwsResource
  module Ec2
    class Vpc < ::AwsResource::Base
      include AwsResource::Concerns::Enumerable

      client_class Aws::EC2::Client
      iterator ::AwsResource::Iterator::SimpleIterator,
               method: :describe_vpcs

      class << self
        # Find by vpc_id
        #
        # @param vpc_id [String]
        # @return AwsResource::Ec2::Vpc
        def find_by_id(vpc_id)
          with_params(vpc_ids: [vpc_id]).first
        end

        # Find by vpc_ids
        #
        # @param vpc_ids [Array]
        # @return Array of AwsResource::Ec2::Vpc
        def find_by_ids(vpc_ids)
          with_params(vpc_ids: vpc_ids).to_a
        end

        # Find by tags
        #
        # @param tags [Hash]
        # @return Array of AwsResource::Ec2::Vpc
        def find_by_tags(tags)
          tag_filter = tags.map do |key, value|
            { name: "tag:#{key}", values: Array.wrap(value) }
          end

          with_params(filters: tag_filter).to_a
        end

        protected

        def extract_instances
          proc do |result|
            result.vpcs.map { |attrs| new(attrs) }
          end
        end
      end
    end
  end
end
