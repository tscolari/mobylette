require 'spec_helper'

describe SkipXhrRequestController do
  render_views

  #######################################################
  # Testing XHR requests
  describe "XHR Requests" do
    it "should not use mobile format for xhr requests" do
      force_mobile_request_agent("Android")
      xhr :get, :index
      response.should render_template(:index)
      response.body.should contain("this is the mobile view")
    end
  end

end
