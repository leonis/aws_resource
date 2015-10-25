module AwsResource
  module Iterator
    class SimpleIterator
      def initialize(client, method, *args, &block)
        @client = client
        @method = method
        @args = args
        @block = block

        @values = []
        @pos = nil
      end

      def next
        load_values if loaded?

        next_value
      end

      def size
        load_values if loaded?
        @values.size
      end

      private

      def next_value
        v = @values.fetch(@pos)
        @pos += 1
        v
      rescue IndexError
        raise StopIteration
      end

      def loaded?
        @pos.nil? && @values.empty?
      end

      def load_values
        @pos = 0

        @values = @block.call(
          @client.send(@method, *@args)
        )
      end
    end
  end
end
