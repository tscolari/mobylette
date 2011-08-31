module Mobylette
  module Controllers
    autoload "RespondToMobileRequests", "mobylette/controllers/respond_to_mobile_requests"
    autoload "Helpers"                , "mobylette/controllers/helpers"
  end

  require 'mobylette/railtie'
end
