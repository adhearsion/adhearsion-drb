require 'spec_helper'

describe AhnDrb::Plugin do
  
  describe "while accessing the plugin configuration" do
    subject { Adhearsion.config}

    it "should retrieve a valid configuration instance" do
      Adhearsion.config.ahn_drb.should be_instance_of Loquacious::Configuration
    end

    it "should configure properly the host" do
      Adhearsion.config.ahn_drb.host.should == "localhost"
    end

    it "should configure properly the port" do
      Adhearsion.config.ahn_drb.port.should == 9050
    end

    it "should configure properly the deny access" do
      Adhearsion.config.ahn_drb.acl.deny.should have(0).hosts
    end

    it "should configure properly the allow access" do
      subject.ahn_drb.acl.allow.should == ["127.0.0.1"]
    end
  
  end

  describe "while configuring a specific config value" do
    before do
      @host = Adhearsion.config[:ahn_drb].host
      @port = Adhearsion.config[:ahn_drb].port
      @allow = Adhearsion.config[:ahn_drb].acl.allow.dup
      @deny = Adhearsion.config[:ahn_drb].acl.deny.dup
    end

    after do
      Adhearsion.config[:ahn_drb].host = @host
      Adhearsion.config[:ahn_drb].port = @port
      Adhearsion.config[:ahn_drb].acl.allow = @allow
      Adhearsion.config[:ahn_drb].acl.deny = @deny
    end

    it "ovewrites properly the host value" do
      Adhearsion.config[:ahn_drb].host = "an-external-host"
      Adhearsion.config[:ahn_drb].host.should == "an-external-host"
    end

    it "ovewrites properly the port value" do
      Adhearsion.config[:ahn_drb].port = 9051
      Adhearsion.config[:ahn_drb].port.should == 9051
    end

    it "ovewrites properly the allow access value" do
      Adhearsion.config[:ahn_drb].acl.allow = ["127.0.0.1", "192.168.10.*"]
      Adhearsion.config[:ahn_drb].acl.allow.should == ["127.0.0.1", "192.168.10.*"]
    end

    it "ovewrites properly the allow access value adding an element" do
      Adhearsion.config[:ahn_drb].acl.allow << "192.168.10.*"
      Adhearsion.config[:ahn_drb].acl.allow.should == ["127.0.0.1", "192.168.10.*"]
    end

    it "ovewrites properly the deny access value" do
      Adhearsion.config[:ahn_drb].acl.deny = ["192.168.*.*"]
      Adhearsion.config[:ahn_drb].acl.deny.should == ["192.168.*.*"]
    end

    it "ovewrites properly the deny access value adding an element" do
      Adhearsion.config[:ahn_drb].acl.deny << "192.168.*.*"
      Adhearsion.config[:ahn_drb].acl.deny.should == ["192.168.*.*"]
    end
  end

  describe "while initializing" do

    it "should start the service" do
      AhnDrb::Plugin::Service.should_receive(:start).and_return true
      Adhearsion::Plugin.init_plugins
    end

  end
end