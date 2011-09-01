class HomeController < ApplicationController
  def index
  end

  def respond_to_test
    respond_to do |format|
      format.html   {render :action => "desktop"}
      format.mobile {render :action => "mobile"}
    end
  end
end
