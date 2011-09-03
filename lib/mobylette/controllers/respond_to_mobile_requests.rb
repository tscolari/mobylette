module Mobylette
  module Controllers

    # Mobylette::Controllers::RespondToMobileRequests includes the respond_to_mobile_requests
    # to your ActionController::Base.
    #
    # The respond_to_mobile_requests method enables the controller mobile handling
    module RespondToMobileRequests
      extend ActiveSupport::Concern

      included do
        helper_method :is_mobile_request?

        # List of mobile agents, from mobile_fu (https://github.com/brendanlim/mobile-fu)
        MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                              'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                              'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                              'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                              'webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|'    +
                              'mobile'
      end

      module ClassMethods

        # This method enables the controller do handle mobile requests
        # You must add this to every controller you want to respond diferently to mobile devices,
        # or make it application wide calling it from the ApplicationController
        #
        # Options:
        # :fall_back_format => :html
        # You may pass a fall_back_format option to the method, it will force the render
        # to look for that other format, in case there is not .mobile file for the view
        #
        # By default, it will fall back to the format of the original request.
        # If you don't want fall back at all, pass :fall_back_format => false
        #
        def respond_to_mobile_requests(options = {})
          return if self.included_modules.include?(Mobylette::Controllers::RespondToMobileRequestsMethods)

          cattr_accessor :fall_back_format
          self.fall_back_format   = options[:fall_back_format]

          self.send(:include, Mobylette::Controllers::RespondToMobileRequestsMethods)
        end
      end

      module InstanceMethods

        private

        # helper method to check if the current request if from a mobile device or not
        def is_mobile_request?
          return true if (request.format.to_s == "mobile") or (params[:format] == "mobile")
          request.user_agent.to_s.downcase =~ /#{MOBILE_USER_AGENTS}/
        end
      end

    end

    # RespondToMobileRequestsMethods is included by respond_to_mobile_requests
    # This will check if the request is from a mobile device and change
    # the request format to :mobile
    module RespondToMobileRequestsMethods
      extend ActiveSupport::Concern

      included do
        before_filter :handle_mobile
      end

      module InstanceMethods
        private

        # Changes the request.form to :mobile, when the request is from
        # a mobile device
        def handle_mobile
          if is_mobile_request?
            request.format    = :mobile
            if self.fall_back_format != false
              request.formats << Mime::Type.new((self.fall_back_format if self.fall_back_format) || params[:format])
            end
          end
        end
      end
    end
  end
end
