require 'spec_helper'

describe IgnoreMobilePathController do
  render_views

  it "it should render the view on the mobile path" do
    force_mobile_request_agent
    get :index
    response.should render_template(:index)
    response.body.should contain("THIS IS THE MOBILE VIEW BUT OUTSIDE THE MOBILE PATH")
  end
end
