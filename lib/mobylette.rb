#
# Rails automatic mobile request support
module Mobylette
  require "mobylette/respond_to_mobile_requests"

  # TestHelpers
  # require "mobylette/helmet"

  require 'mobylette/railtie'
end

# Creating the :mobile format alias
require 'action_controller'
Mime::Type.register_alias "text/html", :mobile
