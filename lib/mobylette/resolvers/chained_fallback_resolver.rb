module Mobylette
  module Resolvers
    class ChainedFallbackResolver < ::ActionView::FileSystemResolver

      # Initializes the fallback resolver with a default
      # mobile format.
      #
      def initialize(formats = {})
        @fallback_formats = formats.reverse_merge!({ mobile: [:mobile] })
        super('app/views')
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
        @fallback_formats = formats.reverse_merge!({ mobile: [:mobile] })
      end

      # Public: finds the right template on the filesystem,
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
    end
  end
end
