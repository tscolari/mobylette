module Mobylette

  # Creates a fallback from mobile to another format
  #
  # Examples:
  #
  #   1. append_view_path Mobylette::FallbackResolver.new('app/views')
  #   2. append_view_path Mobylette::FallbackResolver.new('app/views', :html)
  #   3. append_view_path Mobylette::FallbackResolver.new('app/views', :js)
  #
  # Returns:
  #
  #   1. if a .mobile view is not found it will look for a .html view
  #   2. if a .mobile view is not found it will look for a .html view
  #   3. if a .mobile view is not found it will look for a .js view
  #
  class FallbackResolver < ::ActionView::FileSystemResolver
    # Initializes a mobile fallback resolver
    #
    # - path : views path, usually 'app/views'
    # - default_fallback : the default fallback, usually :html
    #
    def initialize(path, default_fallback = :html)
      @fallback_list = [:mobile, default_fallback]
      super(path)
    end

    # Public: finds the right template on the filesystem,
    #         using fallback if needed
    #
    def find_templates(name, prefix, partial, details)
      format = details[:formats].first

      return super unless format == :mobile

      formats = Array.wrap(@fallback_list)
      details_copy = details.dup
      details_copy[:formats] = formats
      path = Path.build(name, prefix, partial)
      query(path, details_copy, formats)
    end
  end
end
