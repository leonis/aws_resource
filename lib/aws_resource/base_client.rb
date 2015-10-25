module AwsResource
  class BaseClient
    protected

    def resource_enumerator(iterator)
      ResourceEnumerator.new(iterator)
    end

    def logger
      @logger ||= ::AwsResource.logger
    end
  end
end
