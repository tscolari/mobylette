#
# Rails automatic mobile request support
module Mobylette
  module Controllers
    require "mobylette/controllers/respond_to_mobile_requests"
    require "mobylette/controllers/helpers"
  end

  # TestHelpers
  # require "mobylette/helmet"

  require 'mobylette/railtie'
end

# Creating the :mobile format alias
require 'action_controller'
Mime::Type.register_alias "text/html", :mobile
