class SkipXhrRequestController < ApplicationController
  respond_to_mobile_requests :skip_xhr_requests => false

  def index
  end

end
