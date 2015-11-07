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

      def inspect
        "#<AwsResource::Ec2::Instance instance_id:#{instance_id}>"
      end
    end
  end
end
