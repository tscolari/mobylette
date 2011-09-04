require 'spec_helper'

describe ActionController::Base do

  it "ActionController::Base class should respond to the respond_to_mobile_requests" do
    ActionController::Base.respond_to?(:respond_to_mobile_requests).should be_true
  end

  it "should have the :is_mobile_request? method" do
    # works on ruby 1.9.2, but not on 1.8.7:
    #@controller.private_methods.include?(:is_mobile_request?).should be_true

    @controller.send(:is_mobile_request?).should be_nil
  end

  it "should have the :is_mobile_request? method" do
    # works on ruby 1.9.2, but not on 1.8.7:
    #@controller.private_methods.include?(:is_mobile_request?).should be_true

    @controller.send(:is_mobile_view?).should be_nil
  end


end
