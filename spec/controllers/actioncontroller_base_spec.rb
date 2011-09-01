require 'spec_helper'

describe ActionController::Base do

  it "ActionController::Base class should respond to the respond_to_mobile_requests" do
    ActionController::Base.respond_to?(:respond_to_mobile_requests).should be_true
  end

end
