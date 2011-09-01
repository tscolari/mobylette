require 'spec_helper'

describe ApplicationController do

  it "should have the :handle_mobile method" do
    @controller.private_methods.include?(:handle_mobile).should be_true
  end

  it "should have the :is_mobile_request? method?" do
    @controller.private_methods.include?(:is_mobile_request?).should be_true
  end

end
