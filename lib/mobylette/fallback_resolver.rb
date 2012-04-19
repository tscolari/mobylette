module Mobylette
  class FallbackResolver < ::ActionView::FileSystemResolver
    def initialize(path, fallbacks = nil)
      @fallback_list = fallbacks
      super(path)
    end

    def find_templates(name, prefix, partial, details)
      format = details[:formats].first

      return super unless @fallback_list && @fallback_list[format]

      formats = Array.wrap(@fallback_list[format])
      details_copy = details.dup
      details_copy[:formats] = formats
      path = Path.build(name, prefix, partial)
      query(path, details_copy, formats)
    end
  end
end
