require 'spec_helper'

describe HomeController do

  it "should render the index view" do
    get :index
    response.should render_template(:index)
  end

  it "should have the Rails Testing request type by default" do
    get :index
    request.user_agent.should == "Rails Testing"
    @controller.send(:is_mobile_request?).should be_false
  end

  it "should have respond to mobile requests" do
    get :index
    force_mobile_request_agent("Android")
    request.user_agent.should == "Android"
    @controller.send(:is_mobile_request?).should be_true
  end

  it "reset_test_request_agent should reset the user_agent to Rails Testing" do
    get :index
    force_mobile_request_agent("Iphone")
    reset_test_request_agent
    request.user_agent.should == "Rails Testing"
  end



end
