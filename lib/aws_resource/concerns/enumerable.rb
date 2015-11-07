require 'active_support/concern'

module AwsResource::Concerns
  module Enumerable
    extend ActiveSupport::Concern

    included {}

    class_methods do
      include Enumerable

      def client_class(cls)
        @client_class = cls
      end

      def iterator(cls, options)
        @iterator_class = cls
        @iterator_method = options[:method]
      end

      def with_params(options)
        each(options)
      end

      def each(options = {})
        iter = instance_iterator(options)
        return AwsResource::Enumerator.new(iter) unless block_given?

        loop { yield(iter.next) }
      end

      protected

      def client
        @client ||= @client_class.new
      end

      def instance_iterator(options)
        @iterator_class.new(
          client, @iterator_method, options, &extract_instances
        )
      end

      def extract_instances
        fail NotImplementedError
      end
    end
  end
end
