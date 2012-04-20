require 'spec_helper'

module Mobylette
  describe FallbackResolver do

    subject { FallbackResolver.new('app/views') }

    describe "#fallback_list" do

      context "when use_fallback is set to false" do
        it "should return only :mobile" do
          subject.use_fallback(false)
          subject.send(:fallback_list).should == [:mobile]
        end
      end

      context "when use_fallback is set to any value" do
        it "should return :mobile and the use_fallback value" do
          subject.use_fallback(:somestuff)
          subject.send(:fallback_list).should == [:mobile, :somestuff]
        end
      end
    end

    describe "#find_templates" do
      before(:each) do
        @formats = []
        Array.stub(:wrap).and_return(@formats)
        @details = {:formats => []}
      end

      context "mobile request" do
        before(:each) { @details[:formats] = [:mobile] }

        it "should set the details[:formats]" do
          Array.should_receive(:wrap)
          subject.find_templates('', '', '', @details)
          @details[:formats].should == @formats
        end
      end

      context "normal request" do
        before(:each) { @details[:formats] = [:html] }

        it "should not set the details[:formats]" do
          subject.find_templates('', '', '', @details)
          @details[:formats].should == [:html]
        end
      end
    end

  end
end
