class HomeController < ApplicationController

  respond_to_mobile_requests

  def index
  end

  def respond_to_test

    respond_to do |format|
      format.html   {render :action => "desktop"}
      format.mobile {render :action => "mobile"}
    end
  end

  def no_mobile_view

  end

end
