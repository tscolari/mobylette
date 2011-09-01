module Mobylette
  module Controllers
    autoload "RespondToMobileRequests", "mobylette/controllers/respond_to_mobile_requests"
    autoload "Helpers"                , "mobylette/controllers/helpers"
  end

  autoload "TestHelpers"              , "mobylette/test_helpers"
  require 'mobylette/engine'
end

require 'action_controller'
Mime::Type.register_alias "text/html", :mobile
