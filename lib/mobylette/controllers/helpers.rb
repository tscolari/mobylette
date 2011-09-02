module Mobylette
  module Controllers
    module Helpers
      extend ActiveSupport::Concern

      def mobylette_stylesheet_link_tag(*sources)
        options = sources.extract_options!
        if is_mobile_request?
          stylesheet_link_tag(*sulfix_mobile_assets(sources, :css), options)
        else
          stylesheet_link_tag(*sources, options)
        end
      end

      def mobylette_javascript_include_tag(*sources)
        options = sources.extract_options!
        if is_mobile_request?
          javascript_include_tag(*sulfix_mobile_assets(sources, :js), options)
        else
          javascript_include_tag(*sources, options)
        end
      end

      private

      def sulfix_mobile_assets(sources, extension)
        sources.each_index do |index|
          source = sources[index]
          source = source.first unless source.is_a?(String)

          if source =~ /.#{extension}$/
            sources[index]  = "#{source.split(/.#{extension}$/)[0]}_mobile.#{extension}"
          else
            sources[index]  = "#{source}_mobile"
          end
        end
        if sources.size == 1
          sources.first
        else
          sources
        end
      end
    end
  end
end
