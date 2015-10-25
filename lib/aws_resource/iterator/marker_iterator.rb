module AwsResource
  module Iterator
    class MarkerIterator
      def initialize(client, method, *args, &block)
        @client = client
        @method = method
        @args = args
        @block = block
        @marker = nil

        @values = []
        @pos = nil
      end

      def next
        next_value
      end

      def size
        nil
      end

      private

      def next_value
        load_next if load_next?

        v = @values.fetch(@pos)
        @pos += 1
        v
      rescue IndexError
        raise StopIteration
      end

      def load_next?
        @pos.nil? || (@values.size == @pos && @marker)
      end

      def load_next
        @pos = 0 if @pos.nil?
        args = @args.dup

        puts "load #{@pos}, #{@marker}"

        # inject next_token
        args.first.merge!(marker: @marker)

        result = @client.send(@method, *args)
        @marker = result.next_marker

        @values = @block.call(result)
      end
    end
  end
end
