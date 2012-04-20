module Mobylette

  # Creates a fallback from mobile to another format
  #
  # Examples:
  #
  #   append_view_path Mobylette::FallbackResolver.new('app/views')
  #
  # Returns:
  #
  #   if a .mobile view is not found it will look for a .html view
  #
  class FallbackResolver < ::ActionView::FileSystemResolver

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
