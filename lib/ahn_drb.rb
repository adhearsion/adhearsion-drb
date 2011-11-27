require "adhearsion"
require "active_support/dependencies/autoload"

require "ahn_drb/plugin"
require "ahn_drb/version"

module AhnDrb
  
  extend ActiveSupport::Autoload

  autoload :Plugin
  
end
