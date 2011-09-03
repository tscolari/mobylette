class NoFallbackController < ApplicationController

  respond_to_mobile_requests :fall_back => false

  def index

  end

  def test

  end

end
