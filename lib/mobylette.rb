module Mobylette
  module Controllers
    autoload "RespondToMobileRequests", "mobylette/controllers/respond_to_mobile_requests"
    autoload "Helpers"                , "mobylette/controllers/helpers"
  end

  autoload "FallBackResolver"         , "mobylette/fall_back_resolver"

  autoload "Helmet"                   , "mobylette/helmet"
  require 'mobylette/railtie'
end

require 'action_controller'
Mime::Type.register_alias "text/html", :mobile
