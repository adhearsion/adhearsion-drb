require "adhearsion"
require "active_support/dependencies/autoload"

require "adhearsion/drb/plugin"
require "adhearsion/drb/version"

module Adhearsion
  module Drb
    extend ActiveSupport::Autoload

    autoload :Plugin
  end
end
