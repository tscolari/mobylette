module Mobylette
  module Helmet
    # This module is only for testing the view's helpers of the module
    # it simulates the Helmet helpers and the controller methods
    # that are necessary for the tests
    module Helpers
      extend ActiveSupport::Concern

      included do
        cattr_accessor :user_agent
      end

      # Force the request to be a mobile request
      def force_mobile_request_agent
        insert_faker
        ActionController::Base.is_mobile_request = true
      end

      # Reset the request mobile agent of the request
      def reset_test_request_agent
        insert_faker
        ActionController::Base.is_mobile_request = false
      end

      private

      # includes the faker module for faking mobile requests
      def insert_faker
        return if ActionController::Base.included_modules.include?(Mobylette::Helmet::Faker)
        ActionController::Base.send(:include, Mobylette::Helmet::Faker)
      end


    end
  end
end
