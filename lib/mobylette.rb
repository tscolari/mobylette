module Mobylette
  module Controllers
    autoload "RespondToMobileRequests", "mobylette/controllers/respond_to_mobile_requests"
    autoload "Helpers"                , "mobylette/controllers/helpers"
  end

  autoload "TestHelpers"              , "mobylette/test_helpers"
  require 'mobylette/railtie'
end
