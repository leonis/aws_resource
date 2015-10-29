module AwsResource
  module AutoScaling
    class Group < ::AwsResource::Base
      client_class Aws::AutoScaling::Client
      iterator ::AwsResource::Iterator::TokenIterator,
               method: :describe_auto_scaling_groups
      class << self
        protected

        def extract_instances
          proc do |result|
            result.auto_scaling_groups.map { |attrs| new(attrs) }
          end
        end
      end
    end
  end
end
