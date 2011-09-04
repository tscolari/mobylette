require 'spec_helper'

describe HomeController do
  render_views

  it "should have the :handle_mobile method" do
    #
    # Works on ruby 1.9.2 but not on 1.8.7
    # @controller.private_methods.include?(:handle_mobile).should be_true
    # this is a hack, not perfect, but if it didnt have the method it would
    # throw an error, and the test would fail
    @controller.send(:handle_mobile).should be_nil
  end

  it "should render the index view" do
    get :index
    response.should render_template(:index)
    response.body.should contain("this is the html view")
  end

  it "should have the Rails Testing request type by default" do
    get :index
    request.user_agent.should == "Rails Testing"
    @controller.send(:is_mobile_request?).should be_false
  end

  it "should have respond to mobile requests" do
    force_mobile_request_agent("Android")
    get :index
    request.user_agent.should == "Android"
    @controller.send(:is_mobile_request?).should be_true
  end

  it "reset_test_request_agent should reset the user_agent to Rails Testing" do
    force_mobile_request_agent("Iphone")
    reset_test_request_agent
    get :index
    request.user_agent.should == "Rails Testing"
  end

  it "should have the mobile mime_type" do
    force_mobile_request_agent
    get :index
    @controller.send(:is_mobile_request?).should be_true
    response.body.should contain("this is the mobile view")
  end

  it "should render desktop view on non mobile request" do
    reset_test_request_agent
    get :respond_to_test
    response.should render_template(:desktop)
  end

  it "should render mobile view on mobile request" do
    force_mobile_request_agent("Android")
    get :respond_to_test
    response.should render_template(:mobile)
  end

  it "should render mobile view on mobile request when .mobile" do
    get :respond_to_test, :format => "mobile"
    response.should render_template(:mobile)
  end

  it "should display THIS A MOBILE DEVICE on index from mobile" do
    force_mobile_request_agent("Android")
    get :index
    response.body.should contain("THIS A MOBILE DEVICE")
  end

  it "should not display THIS IS NOT A MOBILE DEVICE on index from mobile" do
    force_mobile_request_agent("Android")
    get :index
    response.body.should_not contain("THIS IS NOT A MOBILE DEVICE")
  end

  it "should not display THIS A MOBILE DEVICE on index from non mobile" do
    reset_test_request_agent
    get :index
    response.body.should_not contain("THIS A MOBILE DEVICE")
  end

  it "should display THIS IS NOT A MOBILE DEVICE on index from non mobile" do
    reset_test_request_agent
    get :index
    response.body.should contain("THIS IS NOT A MOBILE DEVICE")
  end

  #######################################################
  # Testing XHR requests
  it "should not use mobile format for xhr requests" do
    force_mobile_request_agent("Android")
    xhr :get, :index
    response.should render_template(:index)
    response.body.should contain("AJAX VIEW")
  end

  #######################################################
  # Testing Session Override

  it "should force mobile view if session says it so" do
    reset_test_request_agent
    set_session_override(:force_mobile)
    get :index
    response.should render_template(:index)
    response.should contain("this is the mobile view")
    response.should contain("THIS IS NOT A MOBILE DEVICE")
  end

  it "should ignore mobile view processing if session says it so" do
    force_mobile_request_agent("Android")
    set_session_override(:ignore_mobile)
    get :index
    response.should render_template(:index)
    response.should contain("this is the html view")
    response.should contain("THIS A MOBILE DEVICE")
  end

end
