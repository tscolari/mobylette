module Mobylette
  module RespondToMobileRequests
    module MobyletteConfiguration

      mattr_accessor :fall_back
      mattr_accessor :skip_xhr_requests

      @@fall_back = nil
      @@skip_xhr_requests = skip_xhr_requests

    end
  end
end
