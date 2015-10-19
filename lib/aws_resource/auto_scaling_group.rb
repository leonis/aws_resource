module AwsResource
  class AutoScalingGroup < Base
    def launch_configuration
      @client.find_launch_configuration_by_name(
        launch_configuration_name
      )
    end
  end

  class LaunchConfiguration < Base
  end
end
