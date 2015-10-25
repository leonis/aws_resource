module AwsResource
  class BaseClient
    def with_params(options)
      dup.tap do |m|
        m.instance_variable_set(:@options, options)
      end
    end

    protected

    def resource_enumerator(iterator)
      ResourceEnumerator.new(iterator)
    end

    def logger
      @logger ||= ::AwsResource.logger
    end
  end
end
