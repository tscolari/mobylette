module Mobylette
  module Controllers
    module Helpers
      module Sprockets
        extend ActiveSupport::Concern

        def mobylette_stylesheet_link_tag(source, options = {})
          if is_mobile_request?
            stylesheet_link_tag(sulfix_mobile_assets(source, :css), options)
          else
            stylesheet_link_tag(source, options)
          end
        end

        def mobylette_javascript_include_tag(source, options = {})
          if is_mobile_request?
            javascript_include_tag(sulfix_mobile_assets(source, :js), options)
          else
            javascript_include_tag(source, options)
          end
        end

        private

        def sulfix_mobile_assets(source, extension)
          if source =~ /.#{extension}$/
            "#{source.split(/.#{extension}$/)[0]}_mobile.#{extension}"
          else
            "#{source}_mobile"
          end
        end
      end
    end
  end
end
