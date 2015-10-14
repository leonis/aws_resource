module AwsResource
  class Base
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

    def logger
      @logger ||= ::AwsResource.logger
    end
  end
end
