require 'spec_helper'

describe DesktopOnlyController do
  # this controller has no actions
  # and do not call respond_to_mobile_requests

  it "should not have the :handle_mobile method" do
    @controller.private_methods.include?(:handle_mobile).should_not be_true
  end

  it "should have the :is_mobile_request? method" do
    # Works on ruby 1.9.2 but not on 1.8.7:
    #@controller.private_methods.include?(:is_mobile_request?).should be_true

    @controller.send(:is_mobile_request?).should be_nil
  end

end
