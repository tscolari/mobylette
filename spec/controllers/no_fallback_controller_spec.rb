require 'spec_helper'

describe NoFallbackController do
  # This controller has fallbacks disabled by: respond_to_mobile_requests :fall_back => false

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

  it "should give an error when there is no mobile view (original format -> html)" do
    force_mobile_request_agent
    was_error = false
    begin
      get(:test)
    rescue ActionView::MissingTemplate => e
      was_error = true
    ensure
      was_error.should be_true
    end
  end

  it "should give an error when there is no mobile view (original format -> html - param)" do
    force_mobile_request_agent
    was_error = false
    begin
      get(:test, :format => :html)
    rescue ActionView::MissingTemplate => e
      was_error = true
    ensure
      was_error.should be_true
    end
  end

  it "should give an error when there is no mobile view (original format -> js)" do
    force_mobile_request_agent
    was_error = false
    begin
      get(:test)
    rescue ActionView::MissingTemplate => e
      was_error = true
    ensure
      was_error.should be_true
    end
  end

end
