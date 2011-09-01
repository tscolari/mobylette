require 'spec_helper'

describe DesktopOnlyController do

  it "should not have the :handle_mobile method" do
    @controller.private_methods.include?(:handle_mobile).should_not be_true
  end

  it "should not have the :is_mobile_request? method" do
    @controller.private_methods.include?(:is_mobile_request?).should_not be_true
  end

end
