module Mobylette
  #TODO add documentation here
  module Helmet
    extend ActiveSupport::Concern

    def force_mobile_request_agent(device_name = "Android")
      request.user_agent = device_name
    end

    def reset_test_request_agent
      request.user_agent = "Rails Testing"
    end

  end
end
