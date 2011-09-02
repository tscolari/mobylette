module Mobylette
  module Helmet
    # This module is only for testing the view helpers of the module
    # it simulates the Helmet helpers and the controller methods
    # that are necessary for the tests
    module Helpers
      @@user_agent = "Rails Testing"

      def force_mobile_request_agent(user_agent = "Android")
        @@user_agent = user_agent
      end

      def reset_test_request_agent
        @@user_agent = "Rails Testing"
      end

      def is_mobile_request?
        @@user_agent.to_s.downcase =~ /#{ActionController::Base::MOBILE_USER_AGENTS}/
      end

    end
  end
end
