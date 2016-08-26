require 'spec_helper'

describe Adhearsion::Drb::Service do

  before :all do
    @host = Adhearsion.config[:adhearsion_drb].host
    @port = Adhearsion.config[:adhearsion_drb].port
    @allow = Adhearsion.config[:adhearsion_drb].acl.allow.dup
    @deny = Adhearsion.config[:adhearsion_drb].acl.deny.dup
    @verbose = Adhearsion.config[:adhearsion_drb].verbose
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
    Adhearsion.config[:adhearsion_drb].verbose = @verbose
  end

  describe "while creating the acl value" do

    it "should return <allow 127.0.0.1> as default value" do
      expect(described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny)).to eq(%w<allow 127.0.0.1>)
    end

    it "should return an empty string when no rule is defined" do
      Adhearsion.config.adhearsion_drb.acl.allow = []
      Adhearsion.config.adhearsion_drb.acl.deny = []
      expect(described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny)).to eq([])
    end

    it "should return an empty string when allow and deny are nil" do
      Adhearsion.config.adhearsion_drb.acl.allow = nil
      Adhearsion.config.adhearsion_drb.acl.deny = nil
      expect(described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny)).to eq([])
    end

    it "should return an empty string when allow and deny are empty" do
      Adhearsion.config.adhearsion_drb.acl.allow = ""
      Adhearsion.config.adhearsion_drb.acl.deny = ""
      expect(described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny)).to eq([])
    end

    describe "having configured deny" do
      before do
        Adhearsion.config.adhearsion_drb.acl.allow = nil
      end

      it "should return an array with <deny 10.1.*.* deny 10.0.*.*>" do
        Adhearsion.config.adhearsion_drb.acl.deny = %w<10.1.*.* 10.0.*.*>
        expect(described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny)).to eq(%w<deny 10.1.*.* deny 10.0.*.*>)
      end

      it "should return an array with <deny 10.1.*.*>" do
        Adhearsion.config.adhearsion_drb.acl.deny = "10.1.*.*"
        expect(described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny)).to eq(%w<deny 10.1.*.*>)
      end
    end

    describe "having configured allow" do
      before do
        Adhearsion.config.adhearsion_drb.acl.deny = nil
      end

      it "should return an array with <allow 127.0.0.1 allow 10.0.0.1> when another IP is allowed" do
        Adhearsion.config.adhearsion_drb.acl.allow = %w<127.0.0.1 10.0.0.1>
        expect(described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny)).to eq(%w<allow 127.0.0.1 allow 10.0.0.1>)
      end

      it "should return an array with <allow 10.0.0.1> when another IP is allowed" do
        Adhearsion.config.adhearsion_drb.acl.allow = "10.0.0.1"
        expect(described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny)).to eq(%w<allow 10.0.0.1>)
      end
    end

    describe "having configured allow and deny" do
      it "should return an array with <allow 127.0.0.1 allow 10.2.*.* deny 10.1.*.* deny 10.0.*.*>" do
        Adhearsion.config.adhearsion_drb.acl.allow = %w<127.0.0.1 10.2.*.*>
        Adhearsion.config.adhearsion_drb.acl.deny = %w<10.1.*.* 10.0.*.*>
        expect(described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny)).to eq(%w<allow 127.0.0.1 allow 10.2.*.* deny 10.1.*.* deny 10.0.*.*>)
      end

      it "should return an array with <allow 127.0.0.1 deny 10.1.*.*>" do
        Adhearsion.config.adhearsion_drb.acl.allow = "127.0.0.1"
        Adhearsion.config.adhearsion_drb.acl.deny = "10.1.*.*"
        expect(described_class.create_acl(Adhearsion.config.adhearsion_drb.acl.allow, Adhearsion.config.adhearsion_drb.acl.deny)).to eq(%w<allow 127.0.0.1 deny 10.1.*.*>)
      end
    end
  end

  describe "setting verbose" do
    before do
      setup_scenario
    end

    def setup_scenario
      Adhearsion.config.adhearsion_drb.verbose = verbose if !verbose.nil?
      Adhearsion::Logging.silence!
      allow(DRb).to receive(:uri).and_return("druby://127.0.0.1")
      allow(DRb).to receive(:start_service)
    end

    def assert_verbose!(asserted_verbose)
      expect(DRb).to receive(:start_service).with(any_args, hash_including(:verbose => asserted_verbose))
      described_class.start
    end

    context "by default" do
      let(:verbose) { nil }
      it { assert_verbose!(false) }
    end

    context "setting verbose to '1'" do
      let(:verbose) { "1" }
      it { assert_verbose!(true) }
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

      def halt_drb_directly!
        DRb.stop_service
      end
    end

    let(:client) { DRbObject.new nil, DRb.uri }

    before(:all) do
      Adhearsion.config.adhearsion_drb.acl.allow     = %q<127.0.0.1>
      Adhearsion.config.adhearsion_drb.acl.deny      = nil
      Adhearsion.config.adhearsion_drb.shared_object = Blah.new

      Adhearsion::Drb::Service.user_stopped = false
      Adhearsion::Drb::Service.start
    end

    it "should return normal Ruby data structures properly over DRb" do
      expect(client.foo).to eq([3, 2, 1])
    end

    it "should raise an exception for a non-existent interface" do
      expect { expect(client.interface.bad_interface).to be [3, 2, 1] }.to raise_error NoMethodError
    end

    it "restarts the server if DRb's thread ends" do
      client.halt_drb_directly!
      sleep 2
      expect(client.foo).to eq([3, 2, 1])
    end

    it "does not start up again if Service.stop is called" do
      expect(Adhearsion::Drb::Service).not_to receive :start
      Adhearsion::Drb::Service.stop
      sleep 0.10
      expect { client.foo }.to raise_error DRb::DRbServerNotFound
    end
  end
end
