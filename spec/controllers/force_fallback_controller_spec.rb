require 'spec_helper'

describe ForceFallbackController do
  # this controller calls respond_to_mobile_requests :fall_back => :js
  # forcing fallback to be javascript
  # index action has html, js and mobile views
  # test  action has html and js only

  render_views

  it "should find the correct view (mobile) when it exists" do
    force_mobile_request_agent
    get :index
    response.should render_template(:index)
    response.body.should contain("MOBILE VIEW")
  end

  it "should find the correct view (html) when it exists" do
    reset_test_request_agent
    get :index
    response.should render_template(:index)
    response.body.should contain("HTML VIEW")
  end

  it "should fall back to the JS format when it doesnt have mobile" do
    force_mobile_request_agent
    get :test
    response.should render_template(:test)
    response.body.should contain("JS VIEW")
  end

  it "should fall back to the JS format when it doesnt have mobile" do
    force_mobile_request_agent
    get :test, :format => :html
    response.should render_template(:test)
    response.body.should contain("JS VIEW")
  end

  it "should fall back to the JS format when it doesnt (js)" do
    force_mobile_request_agent
    get :test, :format => :js
    response.should render_template(:test)
    response.body.should contain("JS VIEW")
  end

end
