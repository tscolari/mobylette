class IgnoreMobilePathController < ApplicationController

  respond_to_mobile_requests :ignore_mobile_view_path => true

  def index

  end

end
