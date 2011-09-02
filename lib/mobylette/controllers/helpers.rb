module Mobylette
  module Controllers
    module Helpers
      extend ActiveSupport::Concern
      module InstanceMethods

        def mobylette_stylesheet_link_tag(*sources)
          if is_mobile_request?
            stylesheet_link_tag(*sulfix_mobile_assets(*sources, :css))
          else
            stylesheet_link_tag(*sources)
          end
        end

        def mobylette_javascript_include_tag(*sources)
          if is_mobile_request?
            javascript_include_tag(*sulfix_mobile_assets(*sources, :js))
          else
            javascript_include_tag(*sources)
          end
        end

        private

        def sulfix_mobile_assets(*sources, extension)
          sources.each_index do |index|
            source          = sources[index]
            source_mobile   = source.split(/.#{extension.to_s}$/)
            sources[index]  = "#{source_mobile[0]}_mobile"
            sources[index] += ".#{extension.to_s}" if source =~ /\.css$/
          end
          return *sources
        end
      end
    end
  end
end
