require 'spec_helper'

module Mobylette
  describe Devices do
    
    describe "#register" do
      it "should accept a {key:value} and insert it into the devices list" do
        Devices.instance.register(crazy_phone: /woot/)
        Devices.instance.instance_variable_get("@devices")[:crazy_phone].should == /woot/
      end

      it "should accept more than one key:value" do
        Devices.instance.register(awesomephone: /waat/, notthatcool: /sad/)
        Devices.instance.instance_variable_get("@devices")[:awesomephone].should == /waat/
        Devices.instance.instance_variable_get("@devices")[:notthatcool].should == /sad/
      end
    end

    describe "#device" do
      it "should return the regex for the informed device" do
        Devices.instance.device(:iphone).should == /iphone/i
      end
    end
  end

  describe "#devices" do
    it "should be an alias to Mobylette::Devices.instance" do
      Mobylette.devices.should == Mobylette::Devices.instance
    end
  end
end
