module Mobylette
  class Engine < ::Rails::Engine
    initializer :mobylette do
      ActiveSupport.on_load(:action_controller) do
        ::ActionController::Base.send(:include, Mobylette::Controllers::RespondToMobileRequests)

        # The view helpers have little differences when using sprockets or rails javascript and stylesheet
        # original methods
        if (Rails.version >= "3.1.0" && Rails.application.config.assets.enabled)
          ::ActionController::Base.helper Mobylette::Controllers::Helpers::Sprockets
        else
          ::ActionController::Base.helper Mobylette::Controllers::Helpers::Rails
        end
      end
    end
  end
end
