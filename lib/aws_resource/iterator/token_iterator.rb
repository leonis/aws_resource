module AwsResource
  module Iterator
    class TokenIterator
      def initialize(client, method, *args, &block)
        @client = client
        @method = method
        @args = args
        @block = block
        @token = nil

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
        @pos.nil? || (@values.size == @pos && @token)
      end

      def load_next
        @pos = 0 if @pos.nil?
        args = @args.dup

        # inject next_token
        args.first.merge!(next_token: @token)

        result = @client.send(@method, *args)
        @token = result.next_token

        @values = @block.call(result)
      end
    end
  end
end
