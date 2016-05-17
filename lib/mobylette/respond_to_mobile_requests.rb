module Mobylette
  # Defines the behavior for responding to mobile requests with a different view.
  #
  # By including this to a controller, it will automaticaly look for a .mobile view
  # instead of a .html, when the request comes from a mobile device.
  #
  # Usage:
  #
  #   class AppicationController < ActionController::Base
  #     include Mobylette::RespondToMobileRequests
  #   end
  #
  #
  # You can define some options:
  #
  #   class...
  #     include Mobylette::RespondToMobileRequests
  #     mobylette_config do |config|
  #       config[:fall_back] = :html
  #       config[:skip_xhr_requests] = false
  #       config[:mobile_user_agents] = proc { /iphone/i }
  #     end
  #     ...
  #   end
  #
  # note: By default it will already fall back to the :html format
  #
  module RespondToMobileRequests
    extend ActiveSupport::Concern

    included do
      helper_method :is_mobile_request?
      helper_method :is_mobile_view?
      helper_method :request_device?

      before_action :handle_mobile

      cattr_accessor :mobylette_options
      @@mobylette_options = Hash.new
      @@mobylette_options[:skip_xhr_requests]  = true
      @@mobylette_options[:fallback_chains]    = { mobile: [:mobile, :html] }
      @@mobylette_options[:mobile_user_agents] = Mobylette::MobileUserAgents.new
      @@mobylette_options[:devices]            = Hash.new
      @@mobylette_options[:skip_user_agents]   = []

      cattr_accessor :mobylette_resolver
      self.mobylette_resolver = Mobylette::Resolvers::ChainedFallbackResolver.new({}, self.view_paths)
      self.mobylette_resolver.replace_fallback_formats_chain(@@mobylette_options[:fallback_chains])
      append_view_path self.mobylette_resolver
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
      #     By default, it will fall back to the html format.
      #     If you don't want fall back at all, pass fall_back: false
      # * skip_xhr_requests: true/false
      #     By default this is set to true. When a xhr request enters in, it will skip the
      #     mobile verification. This will let your ajax calls to work as intended.
      #     You may disable this (actually you will have to) if you are using JQuery Mobile, or
      #     other js framework that uses ajax. To disable, set skip_xhr_requests: false
      # * mobile_user_agents: proc { /user_agents_match/ }
      #     If you want to restrict the user agents that will be considered mobile devices,
      #     you can send a custom proc/object that returns the matching regex you wish.
      # * devices: {device_name: /device_reg/, device2_name: /device2_reg/, ...}
      #     You may register devices for custom behavior by device.
      #     Once a device is registered you may call the helper request_device?(device_symb)
      #     to see if the request comes from that device or not.
      #     By default :iphone, :ipad, :ios and :android are already registered.
      # * skip_user_agents: [:ipad, :android]
      #     Don't consider these user agents mobile devices.
      #
      # Example Usage:
      #
      #   class ApplicationController...
      #     include Mobylette::RespondToMobileRequests
      #     ...
      #     mobylette_config do |config|
      #       config[:fall_back] = :html
      #       config[:skip_xhr_requests] = false
      #       config[:mobile_user_agents] = proc { %r{iphone|android}i }
      #       config[:devices] = {cool_phone: %r{cool\s+phone} }
      #     end
      #     ...
      #   end
      #
      def mobylette_config
        yield(self.mobylette_options)
        configure_fallback_resolver(self.mobylette_options)
        Mobylette.devices.register(self.mobylette_options[:devices]) if self.mobylette_options[:devices]
      end

      private

      # Private: Configures how the resolver shall handle fallbacks.
      #
      # if options has a :fallback_chains key, it will use it
      # as the fallback rules for the resolver, the format should
      # be a hash, where each key defines a array of formats.
      # Example:
      #   options[:fallback_chains]
      #   #=> { iphone: [:iphone, :mobile, :html], mobile: [:mobile, :html] }
      #
      # if there is no :fallback_chains, then it will look for a :fall_back
      # key, that shall define only 1 fallback format to the mobile format.
      # This keep compatibility with older versions.
      # Example:
      #   options[:fall_back]
      #   #=> :html
      #
      def configure_fallback_resolver(options)
        if options[:fall_back]
          logger.warn "DEPRECATED > Mobylette: Please don't user :fall_back to configure fall backs any more. See the README for :fallback_chains instead."
          self.mobylette_resolver.replace_fallback_formats_chain({ mobile: [:mobile, options[:fall_back]] })
        else
          if options[:fallback_chains]
            self.mobylette_resolver.replace_fallback_formats_chain((options[:fallback_chains] || {}).reverse_merge({ mobile: [:mobile, :html] }))
          end
        end
      end
    end

    private

    # Private: Tells if the request comes from a mobile user_agent or not
    #
    def is_mobile_request?
      (not user_agent_excluded?) && !(request.user_agent.to_s.downcase =~ @@mobylette_options[:mobile_user_agents].call).nil?
    end

    # Private: Returns if this request comes from the informed device
    #
    # devive - device symbol. It must be previously registered as a device.
    #
    def request_device?(device)
      (request.user_agent.to_s.downcase =~ (Mobylette.devices.device(device) || %r{not_to_be_matched_please}) ? true : false)
    end

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

    # Private: Rertuns true if the current user agent should be skipped by configuration
    #
    def user_agent_excluded?
      request.user_agent.to_s.downcase =~ Regexp.union([self.mobylette_options[:skip_user_agents]].flatten.map(&:to_s))
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

    # Private: Process the request as mobile
    #
    def handle_mobile
      return if session[:mobylette_override] == :ignore_mobile
      if respond_as_mobile?
        request.format = set_mobile_format
      end
    end

    # Private: Checks if there are fallback_chains defined.
    # if there is, it will try to match the request browser
    # agains a fallback_chain key.
    #
    def set_mobile_format
      if self.mobylette_options[:fallback_chains]
        self.mobylette_options[:fallback_chains].keys.each do |device|
          return device if request_device?(device)
        end
      end
      :mobile
    end

  end
end
