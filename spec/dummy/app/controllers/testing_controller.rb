class TestingController < ApplicationController

  respond_to_mobile_requests

  def index
    render :text => "test"
  end

end
