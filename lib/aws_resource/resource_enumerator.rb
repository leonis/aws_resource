module AwsResource
  class ResourceEnumerator < ::Enumerator
    def initialize(iterator)
      super() do |y|
        loop { y.yield(iterator.next) }
      end
    end
  end
end
