module Mobylette
  module Controllers

    # Mobylette::Controllers::Helpers include few methods to
    # include different css/js files for the mobile and for
    # the normal version of your layout
    #
    # Personal notes:
    # * I'm rethinking and I guess that, since you
    #   may have (and probably will) a different layout file for the
    #   "normal" and mobile version, you probably wont use this at all.
    # * Also I'm not sure it's the case of using 'is_mobile_request?'
    #   or 'is_mobile_view?' check here.'
    module Helpers
      extend ActiveSupport::Concern

      # Adds a "_mobile" sulfix to the files you include (when the request is mobile)
      def mobylette_stylesheet_link_tag(*sources)
        options = sources.extract_options!
        if is_mobile_request?
          stylesheet_link_tag(*sulfix_mobile_assets(sources, :css).insert(-1, options))
        else
          stylesheet_link_tag(*sources.insert(-1, options))
        end
      end

      # Adds a "_mobile" sulfix to the files you include (when the request is mobile)
      def mobylette_javascript_include_tag(*sources)
        options = sources.extract_options!
        if is_mobile_request?
          javascript_include_tag(*sulfix_mobile_assets(sources, :js).insert(-1, options))
        else
          javascript_include_tag(*sources.insert(-1, options))
        end
      end

      private

      # Anex the "_mobile" sulfix to each string in the array,
      # before the .#{extension}, if it exists
      def sulfix_mobile_assets(sources, extension)
        sources.map do |source|
          if source =~ /.#{extension}/
            "#{source.split(/.#{extension}$/)[0]}_mobile.#{extension}"
          else
            "#{source}_mobile"
          end
        end
      end
    end

  end
end
