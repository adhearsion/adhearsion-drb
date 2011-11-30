require 'spec_helper'

module Adhearsion
  describe Drb do

    subject { Drb }

    it "should be a module" do
      subject.should be_kind_of Module
    end
  end
end
