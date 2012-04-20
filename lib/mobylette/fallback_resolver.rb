module Mobylette

  # This manages the fall back from mobile views
  # It only interfers on requests where the format is :mobile,
  # and in case there is no view for the mobile format, it
  # will fall back to the any other format that is configurated.
  #
  # When you insert Mobylette::RespondToMobileRequests to a
  # controller, this class will be the new resolver for that
  # controller.
  #
  # By default this resolver will not fallback to any format.
  # Only is @fallback_to is configurated (by use_fallback)
  #
  # You should not use this by yourself unless you know what
  # you are doing.
  #
  # Examples:
  #
  #   class SomeController < ApplicationController
  #     append_view_path Mobylette::FallbackResolver.new
  #   end
  #
  #
  #   ...
  #     my_controller_resolver = Mobylette::FallbackResolver.new
  #     my_controller_resolver.use_fallback(:html)
  #   ...
  #
  class FallbackResolver < ::ActionView::FileSystemResolver

    def initialize
      super('app/views')
    end

    # Public: Configures what fallback the resolver should use
    #
    # - fallback:
    #     * :html/:js/:xml/... => Falls back to that format
    #
    def use_fallback(fallback)
      @fallback_to = fallback
    end

    # Public: finds the right template on the filesystem,
    #         using fallback if needed
    #
    def find_templates(name, prefix, partial, details)
      details[:formats] = Array.wrap(fallback_list) if details[:formats].first == :mobile
      super
    end

    private

    # Private: formats array, in fall back order
    #
    def fallback_list
      if @fallback_to
        [:mobile, @fallback_to.to_sym]
      else
        [:mobile]
      end
    end
  end
end
