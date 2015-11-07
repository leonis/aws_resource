require 'active_support/core_ext/array/wrap'

module AwsResource
  module Ec2
    class Instance < ::AwsResource::Base
      include AwsResource::Concerns::Enumerable

      client_class Aws::EC2::Client
      iterator ::AwsResource::Iterator::SimpleIterator,
               method: :describe_instances

      class << self
        # Find by instance_id
        #
        # @param instance_id [String]
        # @return AwsResource::Ec2::Instance
        def find_by_id(instance_id)
          with_params(instance_ids: [instance_id]).first
        end

        # Find by instance_ids
        #
        # @param instance_ids [Array]
        # @return Array of AwsResource::Ec2::Instance
        def find_by_ids(instance_ids)
          with_params(instance_ids: instance_ids).to_a
        end

        # Find by tags
        #
        # @param tags [Hash]
        # @return Array of AwsResource::Ec2::Instance
        def find_by_tags(tags)
          tag_filter = tags.map do |key, value|
            { name: "tag:#{key}", values: Array.wrap(value) }
          end

          with_params(filters: tag_filter).to_a
        end

        # Check existance of EC2 instance by instance_id
        #
        # @param instance_id [String]
        # @return true or false
        def exist?(instance_id)
          with_params(instance_ids: [instance_id]).any?
        rescue ::Aws::EC2::Errors::InvalidInstanceIdNotFound,
               ::Aws::EC2::Errors::InvalidInstanceIDMalformed
          false
        end

        protected

        def extract_instances
          proc do |result|
            values = []
            result.each_page do |page|
              page.reservations.each do |reservation|
                values.concat(
                  reservation.instances.map { |attrs| new(attrs) }
                )
              end
            end

            values
          end
        end
      end
    end
  end
end
