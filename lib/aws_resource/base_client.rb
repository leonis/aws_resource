module AwsResource
  class BaseClient

    protected

    def logger
      @logger ||= ::AwsResource.logger
    end
  end
end
