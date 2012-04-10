# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "adhearsion/drb/version"

Gem::Specification.new do |s|
  s.name        = "adhearsion-drb"
  s.version     = Adhearsion::Drb::VERSION
  s.authors     = ["juandebravo", "Ben Langfeld", "Jason Goecke"]
  s.email       = ["juandebravo@gmail.com", "ben@langfeld.me", "jsgoecke@voxeo.com"]
  s.homepage    = ""
  s.summary     = %q{This gem is an Adhearsion plugin that handles the Drb related stuff}
  s.description = %q{This gem is an Adhearsion plugin that handles the Drb related stuff}

  s.rubyforge_project = "adhearsion-drb"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "adhearsion", ["~> 2.0"]
  s.add_runtime_dependency "activesupport", [">= 3.0.10"]
  s.add_runtime_dependency "i18n", ">= 0.5.0"

  s.add_development_dependency "rspec", "~> 2.7.0"
  s.add_development_dependency "flexmock"
  s.add_development_dependency "guard-rspec"
  s.add_development_dependency "rake", ">= 0.9.2"
end

