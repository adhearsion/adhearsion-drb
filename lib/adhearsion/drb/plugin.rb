module Adhearsion
  module Drb

    ##
    # Adhearsion Plugin definition that defines the DRb configuration options
    # and includes a hook to start the DRb service in Adhearsion initialization process
    class Plugin < Adhearsion::Plugin
      extend ActiveSupport::Autoload

      autoload :Service

      # Default configuration
      config :adhearsion_drb do
        host "localhost", :desc => "DRb service host"
        port 9050       , :desc => "DRb service port"

        desc "Access Control List configuration for the DRb service"
        acl {
          allow ["127.0.0.1"], :desc => "list of valid IP addresses to access DRb service"
          deny  []           , :desc => "list of invalid IP addresses to access DRb service"
        }
      end

      # Include the DRb service in plugins initialization process
      init :adhearsion_drb do
        Service.start
      end

    end

  end
end
