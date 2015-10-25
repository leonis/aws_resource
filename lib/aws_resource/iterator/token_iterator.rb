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
        load_next if should_load_next?

        v = @values.fetch(@pos)
        @pos += 1
        v
      rescue IndexError
        raise StopIteration
      end

      def should_load_next?
        @pos.nil? || @values.size == @pos
      end

      def load_next
        @pos = 0 if @pos.nil?
        args = @args.dup

        # inject next_token
        args.first.merge!(next_token: @token)

        @values = @block.call(
          @client.send(@method, *args)
        )
      end
    end
  end
end
