module AwsEnvHelper

  # parse tags string to a Hash
  #
  # ex)
  #   'key=value' => { 'key' => value }
  #   'k1=v1&k2=v2' => { 'k1' => v1, 'k2' => 'v2' }
  #
  # @param value [String]
  # @return Hash
  def parse_tag(value)
    value.split('&')
      .map { |v| Hash[*(v.split('='))] }
      .reduce({}) { |x, y| x.merge(y) }
  end
end
