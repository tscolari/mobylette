module Mobylette
  # Mobylette::Controllers::RespondToMobileRequests includes the respond_to_mobile_requests
  # to your ActionController::Base.
  #
  # The respond_to_mobile_requests method enables the controller mobile handling
  module RespondToMobileRequests
    extend ActiveSupport::Concern

    included do
      helper_method :is_mobile_request?
      helper_method :is_mobile_view?

      before_filter :handle_mobile

      cattr_accessor :mobylette_options
      @@mobylette_options = Hash.new
      @@mobylette_options[:skip_xhr_requests] = true
      @@mobylette_options[:fall_back]         = nil

      append_view_path Mobylette::FallbackResolver.new('app/views')

      # List of mobile agents, from mobile_fu (https://github.com/brendanlim/mobile-fu)
      #
      MOBILE_USER_AGENTS =  'palm|blackberry|nokia|phone|midp|mobi|symbian|chtml|ericsson|minimo|' +
        'audiovox|motorola|samsung|telit|upg1|windows ce|ucweb|astel|plucker|' +
        'x320|x240|j2me|sgh|portable|sprint|docomo|kddi|softbank|android|mmp|' +
        'pdxgw|netfront|xiino|vodafone|portalmmm|sagem|mot-|sie-|ipod|up\\.b|' +
        'webos|amoi|novarra|cdm|alcatel|pocket|ipad|iphone|mobileexplorer|' +
        'mobile|maemo|fennec'
    end

    module ClassMethods
      # This method enables the controller do handle mobile requests
      #
      # You must add this to every controller you want to respond differently to mobile devices,
      # or make it application wide calling it from the ApplicationController
      #
      # Possible options:
      # * fall_back: :html
      #     You may pass a fall_back option to the method, it will force the render
      #     to look for that other format, in case there is not a .mobile file for the view.
      #     By default, it will fall back to the format of the original request.
      #     If you don't want fall back at all, pass fall_back: false
      # * skip_xhr_requests: true/false
      #     By default this is set to true. When a xhr request enters in, it will skip the
      #     mobile verification. This will let your ajax calls to work as intended.
      #     You may disable this (actually you will have to) if you are using JQuery Mobile, or
      #     other js framework that uses ajax. To disable, set skip_xhr_requests: false
      #
      # Example Usage:
      #
      #   class ApplicationController...
      #     include Mobylette::RespondToMobileRequests
      #     ...
      #     mobylette_config do |config|
      #       config[:fall_back] = :html
      #       config[:skip_xhr_requests] = false
      #     end
      #     ...
      #   end
      #
      def mobylette_config
        yield(self.mobylette_options)
      end
    end

    private

    # :doc:
    # Private: Tells if the request comes from a mobile user_agent or not
    #
    def is_mobile_request?
      request.user_agent.to_s.downcase =~ /#{MOBILE_USER_AGENTS}/
    end

    # :doc:
    # Private: Helper method that tells if the currently view is mobile or not
    #
    def is_mobile_view?
      true if (params[:format] == "mobile") || (request.format.to_s == "mobile")
    end

    # Private: This is the method that tells if the request will be threated as mobile
    #          or not
    #
    def respond_as_mobile?
      impediments = stop_processing_because_xhr? || stop_processing_because_param?
      (not impediments) && (force_mobile_by_session? || is_mobile_request? || params[:format] == 'mobile')
    end

    # Private: Returns true if the visitor has the force_mobile set in it's session
    #
    def force_mobile_by_session?
      session[:mobylette_override] == :force_mobile
    end

    # Private: Tells when mobylette should not interfere in the rendering
    #          process because the `skip_mobile` param is set to true
    #
    # Passing :skip_mobile = true to a request will not render it as a mobile
    #
    def stop_processing_because_param?
      return true if params[:skip_mobile] == 'true'
      false
    end

    # Private: Tells when mobylette should or not interfere in the rendering
    #          process because of a xhr request.
    #
    # if the request is not xhr this will aways return false
    # this will only return true for xhr requests, when you explicit want to
    # not skip_xhr_requests.
    #
    def stop_processing_because_xhr?
      if request.xhr? && self.mobylette_options[:skip_xhr_requests]
        true
      else
        false
      end
    end

    # :doc:
    # Private: Process the request as mobile
    #
    def handle_mobile
      return if session[:mobylette_override] == :ignore_mobile
      request.format    = :mobile if respond_as_mobile?
    end

  end
end
