module AwsResource
  class Base
    def initialize(attrs, aws_client = nil)
      @attrs = attrs
      @client = aws_client
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
      ::AwsResource.logger
    end
  end
end
