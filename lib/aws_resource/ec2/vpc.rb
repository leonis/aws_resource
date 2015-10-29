module AwsResource
  module Ec2
    class Vpc < ::AwsResource::Base
      client_class Aws::EC2::Client
      iterator ::AwsResource::Iterator::SimpleIterator,
               method: :describe_vpcs

      class << self
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
