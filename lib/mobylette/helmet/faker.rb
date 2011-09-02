module Mobylette
  module Helmet

    # Forces the helper to think that all requests come
    # from a mobile device
    module Faker
      extend ActiveSupport::Concern

      included do
        cattr_accessor :is_mobile_request
      end

      def is_mobile_request?
        is_mobile_request
      end

    end
  end
end
