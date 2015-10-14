module AwsResource
  class BaseClient
    protected

    def each_with_enum(enum)
      return enum unless block_given?
      loop { yield(enum.next) }
    end

    def logger
      @logger ||= ::AwsResource.logger
    end
  end
end
