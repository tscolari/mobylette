#
# Rails automatic mobile request support
module Mobylette
  module Controllers
    autoload "RespondToMobileRequests", "mobylette/controllers/respond_to_mobile_requests"
    autoload "Helpers"                , "mobylette/controllers/helpers"
  end

  # TestHelpers
  autoload "Helmet"                   , "mobylette/helmet"

  require 'mobylette/railtie'
end

# Creating the :mobile format alias
require 'action_controller'
Mime::Type.register_alias "text/html", :mobile
