ActionController::Responder.class_eval do
    alias :to_ios :to_html
end
