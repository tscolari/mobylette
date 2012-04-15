require 'spec_helper'

module Mobylette
  describe Helmet do

    class MockController < ActionController::Base
      include Mobylette::RespondToMobileRequests
    end

    subject { MockController.new }

    module Helmet
      describe Faker do
        it "should be able to override the is_mobile_request? method" do
          subject.is_mobile_request = true
          subject.send(:is_mobile_request?).should be_true
        end
      end
    end

  end
end
