module AwsResource
  class Base
    class << self
      include Enumerable

      def client_class(cls)
        @client_class = cls
      end

      def iterator(cls, options)
        @iterator_class = cls
        @iterator_method = options[:method]
      end

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

      protected

      def client
        @client ||= @client_class.new
      end

      def instance_iterator(options)
        opts = (@options ? @options.merge(options) : options)

        @iterator_class.new(
          client, @iterator_method, opts, &extract_instances
        )
      end

      def extract_instances
        fail NotImplementedError
      end
    end

    def initialize(attrs, client = nil)
      @attrs = attrs
      @client = client
    end

    def method_missing(method, *args)
      if @attrs.respond_to?(method)
        @attrs.send(method, *args)
      else
        super
      end
    end

    protected

    attr_reader :client

    def logger
      @logger ||= ::AwsResource.logger
    end
  end
end
