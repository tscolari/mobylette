require 'spec_helper'

describe HomeController do
  # This controller calls respond_to_mobile_requests with no params
  # no_mobile_view action has only html
  # mobile action has only mobile
  # index action has html, js and mobile
  # desktop action has only html
  render_views

  it "should have the :handle_mobile method" do
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

  describe "is_mobile_request? and force_mobile_request_agent/reset_test_request_agent" do
    it "should have the Rails Testing request type by default" do
      get :index
      request.user_agent.should == "Rails Testing"
      @controller.send(:is_mobile_request?).should be_false
    end

    it "should, on a mobile request, have 'is_mobile_request?' == true" do
      force_mobile_request_agent("Android")
      get :index
      request.user_agent.should == "Android"
      @controller.send(:is_mobile_request?).should be_true
    end

    it "should, on a mobile request, render the mobile type of view" do
      force_mobile_request_agent
      get :index
      @controller.send(:is_mobile_request?).should be_true
      response.body.should contain("this is the mobile view")
    end

    it "should, on reset_test_request_agent call, reset the user_agent to default (Rails Testing)" do
      force_mobile_request_agent("Iphone")
      reset_test_request_agent
      get :index
      @controller.send(:is_mobile_request?).should be_false
      request.user_agent.should == "Rails Testing"
    end
  end

  describe "Output Rendering" do
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
  end

  describe "respond_to with different views for different request types" do
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

    it "should render mobile view when format => 'mobile' is passed" do
      get :respond_to_test, :format => "mobile"
      response.should render_template(:mobile)
    end
  end

  #######################################################
  # Testing XHR requests
  describe "XHR Requests" do
    it "should not use mobile format for xhr requests by default" do
      force_mobile_request_agent("Android")
      xhr :get, :index
      response.should render_template(:index)
      response.body.should contain("AJAX VIEW")
    end
  end

  #######################################################
  # Testing Session Override
  describe "Session Override" do
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

  ###################################################
  # Param forcing
  describe "Forcing to skip mobile by param" do
    it "should not render mobile view if skip_mobile param is present and set to true" do
      force_mobile_request_agent
      get :index, :skip_mobile => 'true'
      response.should render_template(:index)
      response.should contain("this is the html view")
      response.should contain("THIS A MOBILE DEVICE")
    end
  end

end
