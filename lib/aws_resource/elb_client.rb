module AwsResource
  class ElbClient < BaseClient
    def initialize(options = {})
      @client = ::Aws::ElasticLoadBalancing::Client.new(options)
    end

    def each_elbs(options = {})
      marker = nil
      elbs = []

      loop do
        result = @client.describe_load_balancers(
          options.merge(marker: marker)
        )
        marker = result.next_marker

        result.load_balancer_descriptions.each do |attrs|
          elb = Elb.new(attrs)
          elbs << elb
          yield(elb) if block_given?
        end

        fail StopIteration if marker.nil?
      end

      elbs
    end
    alias_method :elbs, :each_elbs
  end
end
