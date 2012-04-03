require 'drb'
require 'drb/acl'

module Adhearsion
  module Drb
    class Plugin
      class Service

        class << self

          ##
          # Start the DRb service
          def start
            acl = create_acl config.acl.allow, config.acl.deny

            DRb.install_acl ACL.new(acl) unless acl.empty?

            logger.info "Starting DRb on #{config.host}:#{config.port}"
            DRb.start_service "druby://#{config.host}:#{config.port}", create_drb_door
          end

          ##
          # Stop the DRb service
          def stop
            logger.info "Stopping DRb on #{config.host}:#{config.port}"
            DRb.stop_service
          end

          ##
          # Access to Drb plugin configuration
          def config
            @config ||= Adhearsion.config[:adhearsion_drb]
          end

          ##
          # Creates a plain object and injects the Adhearsion RPC methods configured via plugins
          # @return [Object]
          def create_drb_door
            config[:shared_object]
          end

          ##
          # Creates an array that maps the DRb ACL format, that is:
          # - a set of zero or more allowed IP addresses. Any allowed IP address is preceded by an "allow" element
          #       ["allow", "127.0.0.1", "allow", "www.adhearsion.com"]
          # - a set of zero or more allowed IP addresses. Any denied IP address is preceded by an "deny" element
          #       ["deny", "192.168.2.*", "deny", "192.168.3.*"]
          #
          # - All together:
          #       ["allow", "127.0.0.1", "allow", "www.adhearsion.com", "deny", "192.168.2.*", "deny", "192.168.3.*"]
          #
          # @param allow [String, Array] zero or more allowed IPs
          # @param deny [String, Array] zero or more denied IPs
          #
          # @return [Array]
          def create_acl allow = nil, deny = nil
            if allow.is_a?(String) && allow.empty?
              allow = nil
            end
            if deny.is_a?(String) && deny.empty?
              deny = nil
            end

            allow = Array(allow)
            deny  = Array(deny)
            value = String.new

            unless allow.empty? && deny.empty?
              value.concat("allow ").concat(allow.join(" allow ")) unless allow.empty?
              value.concat(" ") if !allow.empty? && !deny.empty?
              value.concat("deny ").concat(deny.join(" deny ")) unless deny.empty?
            end

            value.split
          end

        end
      end
    end
  end
end
