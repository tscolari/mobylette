module Mobylette
  module Controllers

    #
    # Mobylette::Controllers::Helpers include few methods to
    # include different css/js files for the mobile and for 
    # the normal version of your layout
    #
    # Personal note: I'm rethinking and I guess that, since you
    # may have (and probably will) a different layout file for the
    # "normal" and mobile version, you probably wont use this at all
    module Helpers
      extend ActiveSupport::Concern

      # Adds a "_mobile" sulfix to the files you include (when the request is mobile)
      def mobylette_stylesheet_link_tag(*sources)
        options = sources.extract_options!
        if is_mobile_request?
          stylesheet_link_tag(*sulfix_mobile_assets(sources, :css), options)
        else
          stylesheet_link_tag(*sources, options)
        end
      end

      # Adds a "_mobile" sulfix to the files you include (when the request is mobile)
      def mobylette_javascript_include_tag(*sources)
        options = sources.extract_options!
        if is_mobile_request?
          javascript_include_tag(*sulfix_mobile_assets(sources, :js), options)
        else
          javascript_include_tag(*sources, options)
        end
      end

      private

      #
      # Anex the "_mobile" sulfix to each string in the array,
      # before the .#{extension}, if it exists
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
        sources
      end
    end

  end
end
