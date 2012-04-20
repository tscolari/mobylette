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

  end
end
