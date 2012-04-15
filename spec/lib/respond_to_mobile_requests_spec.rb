require 'spec_helper'

module Mobylette
  describe RespondToMobileRequests do

    class MockController < ActionController::Base
      include Mobylette::RespondToMobileRequests

      mobylette_config do |config|
        config[:fall_back] = :something
        config[:skip_xhr_requests] = :something
      end
    end

    subject { MockController.new }

    describe "#mobilette_config" do
      it "should have options configured" do
        subject.mobylette_options[:fall_back].should == :something
        subject.mobylette_options[:skip_xhr_requests].should == :something
      end

      it "should set mobylette_options" do
        subject.class.mobylette_config do |config|
          config[:fall_back] = :js
          config[:skip_xhr_requests] = false
        end
        subject.mobylette_options[:fall_back].should == :js
        subject.mobylette_options[:skip_xhr_requests].should be_false
      end
    end

    describe "#is_mobile_request?" do
      it "should be false for a normal request" do
        subject.stub_chain(:request, :user_agent).and_return('some mozilla')
        subject.send(:is_mobile_request?).should be_false
      end

      RespondToMobileRequests::MOBILE_USER_AGENTS.split('|').each do |agent|
        agent.gsub!('\.', '.') # Ugly rack... but otherwise this will fail for up.b
        it "should be true for the agent #{agent}" do
          subject.stub_chain(:request, :user_agent).and_return(agent)
          subject.send(:is_mobile_request?).should be_true
        end
      end
    end

    describe "#is_mobile_view?" do
      context "from param" do

        before(:each) do
          request = mock("request")
          request.stub(:format).and_return(false)
          subject.stub(:request).and_return(request)
        end

        it "should be true if param[:format] is mobile" do
          subject.stub(:params).and_return({format: 'mobile'})
          subject.send(:is_mobile_view?).should be_true
        end

        it "should be false if param[:format] is not mobile" do
          subject.stub(:params).and_return({format: 'html'})
          subject.send(:is_mobile_view?).should be_false
        end
      end

      context "from request" do

        before(:each) do
          subject.stub(:params).and_return({format: 'html'})
          @request = mock("request")
          subject.stub(:request).and_return(@request)
        end

        it "should be true if request.format is :mobile" do
          @request.stub(:format).and_return(:mobile)
          subject.send(:is_mobile_view?).should be_true
        end

        it "should be false if request.format is not :mobile" do
          @request.stub(:format).and_return(:html)
          subject.send(:is_mobile_view?).should be_false
        end
      end
    end

    describe "#stop_processing_because_xhr?" do

      context "this is a xhr request" do
        before(:each) do
          subject.stub_chain(:request, :xhr?).and_return(true)
        end

        it "should return false if :skip_xhr_requests is false" do
          subject.mobylette_options[:skip_xhr_requests] = false
          subject.send(:stop_processing_because_xhr?).should be_false
        end

        it "should return true if :skip_xhr_requests is true" do
          subject.mobylette_options[:skip_xhr_requests] = true
          subject.send(:stop_processing_because_xhr?).should be_true
        end

      end

      context "this is not a xhr request" do
        before(:each) do
          subject.stub_chain(:request, :xhr?).and_return(false)
        end

        it "should return false when :skip_xhr_requests is false" do
          subject.mobylette_options[:skip_xhr_requests] = false
          subject.send(:stop_processing_because_xhr?).should be_false
        end

        it "should return false when :skip_xhr_requests is true" do
          subject.mobylette_options[:skip_xhr_requests] = true
          subject.send(:stop_processing_because_xhr?).should be_false
        end

      end
    end

    describe "#stop_processing_because_param?" do
      it "should be true if the param is present" do
        subject.stub(:params).and_return(skip_mobile: 'true')
        subject.send(:stop_processing_because_param?).should be_true
      end

      it "should be false if the param is not present" do
        subject.stub(:params).and_return({})
        subject.send(:stop_processing_because_param?).should be_false
      end
    end

    describe "#force_mobile_by_session?" do
      it "should be true if the force_mobile is enabled in the session" do
        subject.stub(:session).and_return({mobylette_override: :force_mobile})
        subject.send(:force_mobile_by_session?).should be_true
      end

      it "should be false if the force_mobile is not enabled in the session" do
        subject.stub(:session).and_return({})
        subject.send(:force_mobile_by_session?).should be_false
      end
    end

    describe "#respond_as_mobile?" do
      context "with impediments" do

        before(:each) do
          subject.stub(:stop_processing_because_xhr?).and_return(false)
          subject.stub(:stop_processing_because_param?).and_return(false)
          subject.stub(:force_mobile_by_session?).and_return(true)
          subject.stub(:is_mobile_request?).and_return(true)
          subject.stub(:params).and_return({format: 'mobile'})
        end

        it "should return false if stop_processing_because_xhr? is true" do
          subject.stub(:stop_processing_because_xhr?).and_return(true)
          subject.send(:respond_as_mobile?).should be_false
        end

        it "should return false if stop_processing_because_xhr? is false" do
          subject.stub(:stop_processing_because_xhr?).and_return(false)
          subject.send(:respond_as_mobile?).should be_true
        end

        it "should return false if stop_processing_because_param? is true" do
          subject.stub(:stop_processing_because_param?).and_return(true)
          subject.send(:respond_as_mobile?).should be_false
        end

        it "should return false if stop_processing_because_param? is false" do
          subject.stub(:stop_processing_because_param?).and_return(false)
          subject.send(:respond_as_mobile?).should be_true
        end
      end

      context "with no impediments" do
        before(:each) do
          subject.stub(:stop_processing_because_xhr?).and_return(false)
          subject.stub(:stop_processing_because_param?).and_return(false)
          subject.stub(:force_mobile_by_session?).and_return(false)
          subject.stub(:is_mobile_request?).and_return(false)
          subject.stub(:params).and_return({})
        end

        it "should be true if force_mobile_by_session? is true" do
          subject.stub(:force_mobile_by_session?).and_return(true)
          subject.send(:respond_as_mobile?).should be_true
        end

        it "should be true if is_mobile_request? is true" do
          subject.stub(:is_mobile_request?).and_return(true)
          subject.send(:respond_as_mobile?).should be_true
        end

        it "should be true if params[:format] is mobile" do
          subject.stub(:params).and_return({format: 'mobile'})
          subject.send(:respond_as_mobile?).should be_true
        end
      end
    end

    describe "#handle_mobile" do
      it "should be false when mobylette_override is set to ignore_mobile in the session" do
        subject.stub(:session).and_return({mobylette_override: :ignore_mobile})
        subject.send(:handle_mobile).should be_false
      end

      it "should be nil if this is not supposed to respond_as_mobile" do
        subject.stub(:session).and_return({})
        subject.stub(:respond_as_mobile?).and_return(false)
        subject.send(:handle_mobile).should be_nil
      end

      context "respond_as_mobile? is true" do
        before(:each) do
          subject.stub(:session).and_return({})
          subject.stub(:respond_as_mobile?).and_return(true)
          @request = mock("request")
          @format  = mock("old_format")
          @format.stub(:to_sym).and_return(:old_format)
          @request.stub(:format).and_return(@format)
          @request.stub(:format=).and_return { |new_value| @format = new_value }
          @formats = []
          @request.stub(:formats).and_return(@formats)
          subject.stub(:request).and_return(@request)
          subject.mobylette_options[:fall_back] = false
        end

        it "should set request.format to :mobile" do
          subject.send(:handle_mobile)
          @format.should == :mobile
        end

        it "should have a fall back to the original format when fall_back is nil" do
          subject.mobylette_options[:fall_back] = nil
          subject.send(:handle_mobile)
          @formats.include?(Mime::Type.new :old_format).should be_true
        end

        it "should have a fall back to :html when fall_back is :html" do
          subject.mobylette_options[:fall_back] = :html
          subject.send(:handle_mobile)
          @formats.include?(Mime::Type.new :html).should be_true
        end
      end
    end
  end
end
