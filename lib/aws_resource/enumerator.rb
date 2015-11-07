module AwsResource
  class Enumerator < ::Enumerator
    def initialize(iterator)
      super() do |y|
        loop { y.yield(iterator.next) }
      end

      lazy if lazy_enumerable?
    end

    private

    def lazy_enumerable?
      ruby_major_version >= 2
    end

    def ruby_major_version
      RUBY_VERSION.split('.')[0].to_i
    end
  end
end
