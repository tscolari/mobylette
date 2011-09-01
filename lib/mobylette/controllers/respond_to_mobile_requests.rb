module Mobylette
  module Controllers
    module RespondToMobileRequests
      extend ActiveSupport::Concern

      module ClassMethods
        def respond_to_mobile_requests
          return if self.included_modules.include?(Mobylette::Controllers::RespondToMobileRequestsMethods)
          self.send(:include, Mobylette::Controllers::RespondToMobileRequestsMethods)
        end
      end

    end

    module RespondToMobileRequestsMethods
      extend ActiveSupport::Concern

      included do
        before_filter :handle_mobile
        helper_method :is_mobile_request?
        MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                              'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                              'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                              'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                              'webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|'    +
                              'mobile'
      end

      module ClassMethods

      end

      module InstanceMethods

        private

        def handle_mobile
          request.format = :mobile if is_mobile_request?
        end

        def is_mobile_request?
          request.user_agent.to_s.downcase =~ /#{MOBILE_USER_AGENTS}/
        end

      end
    end
  end
end
