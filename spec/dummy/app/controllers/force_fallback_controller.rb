class ForceFallbackController < ApplicationController

  respond_to_mobile_requests :fall_back => :js

  def index

  end

  def test

  end

end
