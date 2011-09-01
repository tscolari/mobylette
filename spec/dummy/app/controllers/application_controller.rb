class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to_mobile_requests
end
