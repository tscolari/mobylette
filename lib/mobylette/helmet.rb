module Mobylette
  # Mobylette::Helmet provides helper methods to help you when testing your controllers
  # for a mobile request.
  #
  # You must include Mobylette::Helmet into your test case, in the README there is more
  # documentation about how to make this test wide.
  module Helmet
    extend ActiveSupport::Concern
    require "mobylette/helmet/helpers"
    require "mobylette/helmet/faker"

    # Force the request for the user_agent
    #
    # Remember to add it BEFORE the request
    #
    # Example:
    #
    #   it "should render the mobile_device view on mobile request" do
    #     force_mobile_request_agent("Android")
    #     get :index
    #     response.should render_template(:mobile_device)
    #   end
    def force_mobile_request_agent(user_agent = "Android")
      request.user_agent = user_agent
    end

    # Reset the user_aget to the default ("Rails Testing")
    #
    # Remember to add it BEFORE the request
    #
    # Example:
    #
    #   it "should render the normal_view view on mobile request" do
    #     reset_test_request_agent
    #     get :index
    #     response.should render_template(:normal_view)
    #   end
    def reset_test_request_agent
      request.user_agent = "Rails Testing"
    end

    # set_session_override will set the 'value' to the session override control
    # value may be:
    # * :ignore_mobile  -> This will disable mobile checking, and the original format will be rendered
    # * :force_mobile   -> This will force to all requests for this session be mobile (except xhr)
    # * nil             -> This will disable session override
    def set_session_override(value)
      session[:mobylette_override] = value
    end

  end
end
