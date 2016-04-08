require 'action_view'
require 'action_view/template/resolver'

module Mobylette
  module Resolvers
    class ChainedFallbackResolver < ::ActionView::FileSystemResolver
      DEFAULT_PATTERN = "{:path}/:prefix/:action{.:locale,}{.:formats,}{.:handlers,}"

      # Initializes the fallback resolver with a default
      # mobile format.
      #
      def initialize(formats = {}, view_paths = ['app/views'])
        @fallback_formats = formats
        @paths = view_paths.map { |view_path| File.expand_path(view_path)}
        super(@paths.first, DEFAULT_PATTERN)
      end

      # Updates the fallback resolver replacing the
      # fallback format hash.
      #
      # formats - hash of fallbacks, example:
      #
      #   formats = {
      #     mobile: [:mobile, :html],
      #     iphone: [:iphone, :ios, :mobile, :html],
      #     android: [:android, :mobile],
      #     ...
      #   }
      #
      # It will add the fallback chain array of the 
      # request.format to the resolver.
      # 
      # If the format.request is not defined in formats,
      # it will behave as a normal FileSystemResovler.
      #
      def replace_fallback_formats_chain(formats)
        @fallback_formats = formats
      end

      private

      # Private: finds the right template on the filesystem,
      #         using fallback if needed
      #
      def find_templates(name, prefix, partial, details)
        # checks if the format has a fallback chain
        if @fallback_formats.has_key?(details[:formats].first)
          details = details.dup
          details[:formats] = Array.wrap(@fallback_formats[details[:formats].first]) 
        end
        super(name, prefix, partial, details)
      end

      # Helper for building query glob string based on resolver's pattern.
      def build_query(path, details)
        query = @pattern.dup

        prefix = path.prefix.empty? ? "" : "#{escape_entry(path.prefix)}\\1"
        query.gsub!(/\:prefix(\/)?/, prefix)

        partial = escape_entry(path.partial? ? "_#{path.name}" : path.name)
        query.gsub!(/\:action/, partial)

        details.each do |ext, variants|
          query.gsub!(/\:#{ext}/, "{#{variants.compact.uniq.join(',')}}")
        end

        query.gsub!(/\:path/, "#{@paths.compact.uniq.join(',')}")
      end
    end
  end
end
