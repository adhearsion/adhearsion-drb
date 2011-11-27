require 'spec_helper'

describe AhnDrb do
  
  subject { AhnDrb }
  
  it "should be a module" do
    subject.should be_kind_of Module
  end
end