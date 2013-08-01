require 'spec_helper'

describe Adhearsion::Drb::Service do

  before :all do
    @host = Adhearsion.config[:adhearsion_drb].host
    @port = Adhearsion.config[:adhearsion_drb].port
    @allow = Adhearsion.config[:adhearsion_drb].acl.allow.dup
    @deny = Adhearsion.config[:adhearsion_drb].acl.deny.dup
    # Use a random high port to prevent concurrent test runs from getting
    # Errno::EADDRINUSE
    # Ruby 1.9.2 version of #rand only allows 1 arg; do some math to keep the range right
    Adhearsion.config[:adhearsion_drb].port = rand(65535 - 1024) + 1024
  end

  after :all do
    Adhearsion.config[:adhearsion_drb].host = @host
    Adhearsion.config[:adhearsion_drb].port = @port
    Adhearsion.config[:adhearsion_drb].acl.allow = @allow
    Adhearsion.config[:adhearsion_drb].acl.deny = @deny
  end

  describe "while creating the acl value" do

    it "should return <allow 127.0.0.1> as default value" do
      described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny).should == %w<allow 127.0.0.1>
    end

    it "should return an empty string when no rule is defined" do
      Adhearsion.config.adhearsion_drb.acl.allow = []
      Adhearsion.config.adhearsion_drb.acl.deny = []
      described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny).should == []
    end

    it "should return an empty string when allow and deny are nil" do
      Adhearsion.config.adhearsion_drb.acl.allow = nil
      Adhearsion.config.adhearsion_drb.acl.deny = nil
      described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny).should == []
    end

    it "should return an empty string when allow and deny are empty" do
      Adhearsion.config.adhearsion_drb.acl.allow = ""
      Adhearsion.config.adhearsion_drb.acl.deny = ""
      described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny).should == []
    end

    describe "having configured deny" do
      before do
        Adhearsion.config.adhearsion_drb.acl.allow = nil
      end

      it "should return an array with <deny 10.1.*.* deny 10.0.*.*>" do
        Adhearsion.config.adhearsion_drb.acl.deny = %w<10.1.*.* 10.0.*.*>
        described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny).should == %w<deny 10.1.*.* deny 10.0.*.*>
      end

      it "should return an array with <deny 10.1.*.*>" do
        Adhearsion.config.adhearsion_drb.acl.deny = "10.1.*.*"
        described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny).should == %w<deny 10.1.*.*>
      end
    end

    describe "having configured allow" do
      before do
        Adhearsion.config.adhearsion_drb.acl.deny = nil
      end

      it "should return an array with <allow 127.0.0.1 allow 10.0.0.1> when another IP is allowed" do
        Adhearsion.config.adhearsion_drb.acl.allow = %w<127.0.0.1 10.0.0.1>
        described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny).should == %w<allow 127.0.0.1 allow 10.0.0.1>
      end

      it "should return an array with <allow 10.0.0.1> when another IP is allowed" do
        Adhearsion.config.adhearsion_drb.acl.allow = "10.0.0.1"
        described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny).should == %w<allow 10.0.0.1>
      end
    end

    describe "having configured allow and deny" do

      it "should return an array with <allow 127.0.0.1 allow 10.2.*.* deny 10.1.*.* deny 10.0.*.*>" do
        Adhearsion.config.adhearsion_drb.acl.allow = %w<127.0.0.1 10.2.*.*>
        Adhearsion.config.adhearsion_drb.acl.deny = %w<10.1.*.* 10.0.*.*>
        described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny).should == %w<allow 127.0.0.1 allow 10.2.*.* deny 10.1.*.* deny 10.0.*.*>
      end

      it "should return an array with <allow 127.0.0.1 deny 10.1.*.*>" do
        Adhearsion.config.adhearsion_drb.acl.allow = "127.0.0.1"
        Adhearsion.config.adhearsion_drb.acl.deny = "10.1.*.*"
        described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny).should == %w<allow 127.0.0.1 deny 10.1.*.*>
      end
    end
  end

  describe "while running the Drb service" do
    before :all do
      Adhearsion::Logging.silence!
    end

    class Blah
      def foo
        [3,2,1]
      end
    end

    let :client do
      DRbObject.new nil, DRb.uri
    end

    before do
      Adhearsion.config.adhearsion_drb.acl.allow = %q<127.0.0.1>
      Adhearsion.config.adhearsion_drb.acl.deny = nil
      Adhearsion.config.adhearsion_drb.shared_object = Blah.new
      # Use a random high port to prevent concurrent test runs from getting
      # Errno::EADDRINUSE
      Adhearsion.config[:adhearsion_drb].port = rand(65535 - 1024) + 1024

      Adhearsion::Plugin.init_plugins
    end

    after do
      Adhearsion::Drb::Service.stop
    end

    it "should return normal Ruby data structures properly over DRb" do
      client.foo.should == [3, 2, 1]
    end

    it "should raise an exception for a non-existent interface" do
      lambda { client.interface.bad_interface.should be [3, 2, 1] }.should raise_error NoMethodError
    end

  end

end
