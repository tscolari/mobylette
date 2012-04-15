module Mobylette
  # Gem's Configuration as Railtie
  #
  # Automatic inlcudes Mobylette::Controllers::RespondToMobileRequests to ActiveController::Base and
  # load Mobylette::Controllers::Helpers as ActionController::Base helpers
  class Railtie < ::Rails::Railtie
  end
end
