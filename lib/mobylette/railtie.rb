module Mobylette
  class Railtie < ::Rails::Railtie
    initializer :mobylette do
      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.send(:include, Mobylette::Controllers::RespondToMobileRequests)
        ::ActionController::Base.helper Mobylette::Controllers::Helpers
      end
    end
  end
end
