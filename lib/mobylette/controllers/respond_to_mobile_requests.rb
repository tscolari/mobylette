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
        helper_method :is_mobile_view?

        # List of mobile agents, from mobile_fu (https://github.com/brendanlim/mobile-fu)
        MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
                              'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
                              'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
                              'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
                              'webos|amoi|novarra|cdm|alcatel|pocket|iphone|mobileexplorer|mobile'
      end

      module ClassMethods

        # This method enables the controller do handle mobile requests
        #
        # You must add this to every controller you want to respond differently to mobile devices,
        # or make it application wide calling it from the ApplicationController
        #
        # Options:
        # * :fall_back => :html
        #     You may pass a fall_back option to the method, it will force the render
        #     to look for that other format, in case there is not a .mobile file for the view.
        #     By default, it will fall back to the format of the original request.
        #     If you don't want fall back at all, pass :fall_back => false
        # * :skip_xhr_requests => true/false
        #     By default this is set to true. When a xhr request enters in, it will skip the
        #     mobile verification. This will let your ajax calls to work as intended.
        #     You may disable this (actually you will have to) if you are using JQuery Mobile, or
        #     other js framework that uses ajax. To disable, set :skip_xhr_requests => false
        def respond_to_mobile_requests(options = {})
          return if self.included_modules.include?(Mobylette::Controllers::RespondToMobileRequestsMethods)

          options.reverse_merge!({
            :skip_xhr_requests        => true
          })

          cattr_accessor :mobylette_options
          # works on 1.9, but not on 1.8
          #valid_options = [:fall_back, :skip_xhr_requests]
          #self.mobylette_options = options.reject {|option| !valid_options.include?(option)}
          self.mobylette_options = options

          self.send(:include, Mobylette::Controllers::RespondToMobileRequestsMethods)
        end
      end

      private

      # :doc:
      # This helper returns exclusively if the request's  user_aget is from a mobile
      # device or not.
      def is_mobile_request?
        request.user_agent.to_s.downcase =~ /#{MOBILE_USER_AGENTS}/
      end

      # :doc:
      # This helper returns exclusively if the current format is mobile or not
      def is_mobile_view?
        true if (request.format.to_s == "mobile") or (params[:format] == "mobile")
      end
    end

    # RespondToMobileRequestsMethods is included by respond_to_mobile_requests
    #
    # This will check if the request is from a mobile device and change
    # the request format to :mobile
    module RespondToMobileRequestsMethods
      extend ActiveSupport::Concern

      included do
        before_filter :handle_mobile
      end

      private

      # Returns true if this request should be treated as a mobile request
      def respond_as_mobile?
        processing_xhr_requests? and skip_mobile_param_not_present? and (force_mobile_by_session? or is_mobile_request? or (params[:format] == 'mobile'))
      end

      # Returns true if the visitor has de force_mobile session
      def force_mobile_by_session?
        session[:mobylette_override] == :force_mobile
      end

      # Returns true when ?skip_mobile=true is not passed to the request
      def skip_mobile_param_not_present?
        params[:skip_mobile] != 'true'
      end

      # Returns true only if treating XHR requests (when skip_xhr_requests are set to false) or
      # or when this is a non xhr request
      def processing_xhr_requests?
        not self.mobylette_options[:skip_xhr_requests] && request.xhr?
      end

      # :doc:
      # Changes the request.form to :mobile, when the request is from
      # a mobile device
      def handle_mobile
        return if session[:mobylette_override] == :ignore_mobile
        if respond_as_mobile?

          original_format   = request.format.to_sym
          request.format    = :mobile
          if self.mobylette_options[:fall_back] != false
            request.formats << Mime::Type.new(self.mobylette_options[:fall_back] || original_format)
          end
        end
      end

    end
  end
end
