module AwsResource
  class ElbClient < BaseClient
    include Enumerable

    def initialize(options = {})
      @client = ::Aws::ElasticLoadBalancing::Client.new(options)
      @options = {}
    end

    def each(options = {})
      iter = load_balancers_iterator(options)
      return resource_enumerator(iter) unless block_given?

      loop { yield(iter.next) }
    end

    # Find ElasticLoadBalancing by name
    #
    # @param name [String] load_balancer_name
    # @return AwsResource::Elb instance or nil
    def find_by_name(elb_name)
      elbs(load_balancer_names: [elb_name]).first
    rescue Aws::ElasticLoadBalancing::Errors::LoadBalancerNotFound,
           Aws::ElasticLoadBalancing::Errors::ValidationError => e
      logger.warn e
      nil
    end

    private

    def load_balancers_iterator(options)
      opts = (@options ? @options.merge(options) : options)

      AwsResource::Iterator::MarkerIterator.new(
        @client, :describe_load_balancers, opts, &extract_load_balancers
      )
    end

    def extract_load_balancers
      proc do |result|
        result.load_balancer_descriptions.map do |attrs|
          Elb.new(attrs)
        end
      end
    end
  end
end
