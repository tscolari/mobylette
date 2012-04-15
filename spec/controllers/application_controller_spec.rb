require 'spec_helper'

describe ApplicationController do

  describe 'Helmet' do

    describe "#force_mobile_request_agent" do
      it "should set request.user_agent to Android by default" do
        force_mobile_request_agent
        request.user_agent.should == 'Android'
      end

      it "should set request.user_agent to whatever the argument is" do
        force_mobile_request_agent(:any_value)
        request.user_agent.should == :any_value
      end
    end

    describe "#reset_test_request_agent" do
      it "should reset request.user_agent to rails default" do
        force_mobile_request_agent(:something_else)
        request.user_agent.should == :something_else
        reset_test_request_agent
        request.user_agent.should == 'Rails Testing'
      end
    end

    describe "#set_session_override" do
      it "should set the session[mobylette_override] to whatever value the argument is" do
        set_session_override(:super_testing)
        session[:mobylette_override].should == :super_testing
      end
    end

  end

end
