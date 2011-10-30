require 'spec_helper'

describe DefaultFallbackController do
  # This controller calls respond_to_mobile_requests with no params
  # Index action has views for html, js and mobile
  # Test  action has only html and js

  render_views

  it "should find the correct view when it exists" do
    force_mobile_request_agent
    get :index
    response.should render_template(:index)
    response.body.should contain("MOBILE VIEW")
  end

  it "should find the correct view when it exists" do
    reset_test_request_agent
    get :index
    response.should render_template(:index)
    response.body.should contain("HTML VIEW")
  end

  it "should fall back to the default request format when it doesnt" do
    force_mobile_request_agent
    get :test
    response.should render_template(:test)
    response.body.should contain("HTML VIEW")
  end

  it "should fall back to the default request format when it doesnt (js)" do
    force_mobile_request_agent
    get :test, :format => :js
    response.should render_template(:test)
    response.body.should contain("JS VIEW")
  end
end
