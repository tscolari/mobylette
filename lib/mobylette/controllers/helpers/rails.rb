module Mobylette
  module Controllers
    module Helpers
      module Rails
        extend ActiveSupport::Concern

        def mobylette_stylesheet_link_tag(*sources)
          if is_mobile_request?
            options = sources.extract_options!
            stylesheet_link_tag(sulfix_mobile_assets(source, :css).merge options)
          else
            stylesheet_link_tag(sources)
          end
        end

        def mobylette_javascript_include_tag(*sources)
          if is_mobile_request?
            options = sources.extract_options!
            javascript_include_tag(sulfix_mobile_assets(sources, :js).merge options)
          else
            javascript_include_tag(sources)
          end
        end

        private

        def sulfix_mobile_assets(sources, extension)
          sources.each_index do |index|
            if sources[index] =~ /.#{extension}$/
              sources[index]  = "#{sources[index].split(/.#{extension}$/)[0]}_mobile.#{extension}"
            else
              sources[index] += "_mobile"
            end
            sources
          end
        end
      end
    end
  end
end
