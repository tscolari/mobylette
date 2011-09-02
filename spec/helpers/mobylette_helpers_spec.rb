require 'spec_helper'

describe Mobylette::Controllers::Helpers do
  include Sprockets::Helpers::RailsHelper
  include Mobylette::Helmet::Helpers

  describe "mobylette_stylesheet_link_tag" do
    it "should not change the files names when the request is not mobile" do
      reset_test_request_agent
      helper.mobylette_stylesheet_link_tag("application").should              == stylesheet_link_tag("application")
      helper.mobylette_stylesheet_link_tag("application.css").should          == stylesheet_link_tag("application.css")
      helper.mobylette_stylesheet_link_tag("application", "home").should      == stylesheet_link_tag("application", "home")
      helper.mobylette_stylesheet_link_tag("application.css", "home").should  == stylesheet_link_tag("application.css", "home")
    end

    it "should add the '_mobile' sulfix to the files names when the request is mobile" do
      force_mobile_request_agent
      helper.mobylette_stylesheet_link_tag("application").should              == stylesheet_link_tag("application_mobile")
      helper.mobylette_stylesheet_link_tag("application.css").should          == stylesheet_link_tag("application_mobile.css")
      helper.mobylette_stylesheet_link_tag("application", "home").should      == stylesheet_link_tag("application_mobile", "home_mobile")
      helper.mobylette_stylesheet_link_tag("application.css", "home").should  == stylesheet_link_tag("application_mobile.css", "home_mobile")
    end

    it "should add the '_mobile' sulfix to the files names when the request is mobile" do
      force_mobile_request_agent
      helper.mobylette_stylesheet_link_tag("application", :id => "myid").should              == stylesheet_link_tag("application_mobile", :id => "myid")
      helper.mobylette_stylesheet_link_tag("application.css", :id => "myid").should          == stylesheet_link_tag("application_mobile.css", :id => "myid")
      helper.mobylette_stylesheet_link_tag("application", "home", :id => "myid").should      == stylesheet_link_tag("application_mobile", "home_mobile", :id => "myid")
      helper.mobylette_stylesheet_link_tag("application.css", "home", :id => "myid").should  == stylesheet_link_tag("application_mobile.css", "home_mobile", :id => "myid")
    end
  end

  describe "mobylette_javascript_include_tag" do
    it "should not change the files names when the request is not mobile" do
      reset_test_request_agent
      helper.mobylette_javascript_include_tag("application").should              == javascript_include_tag("application")
      helper.mobylette_javascript_include_tag("application.js").should           == javascript_include_tag("application.js")
      helper.mobylette_javascript_include_tag("application", "home").should      == javascript_include_tag("application", "home")
      helper.mobylette_javascript_include_tag("application.js", "home").should   == javascript_include_tag("application.js", "home")
    end

    it "should add the '_mobile' sulfix to the files names when the request is mobile" do
      force_mobile_request_agent
      helper.mobylette_javascript_include_tag("application").should              == javascript_include_tag("application_mobile")
      helper.mobylette_javascript_include_tag("application.js").should           == javascript_include_tag("application_mobile.js")
      helper.mobylette_javascript_include_tag("application", "home").should      == javascript_include_tag("application_mobile", "home_mobile")
      helper.mobylette_javascript_include_tag("application.js", "home").should   == javascript_include_tag("application_mobile.js", "home_mobile")
    end

    it "should add the '_mobile' sulfix to the files names when the request is mobile with options" do
      force_mobile_request_agent
      helper.mobylette_javascript_include_tag("application", :id => "myid").should              == javascript_include_tag("application_mobile", :id => "myid")
      helper.mobylette_javascript_include_tag("application.js", :id => "myid").should           == javascript_include_tag("application_mobile.js", :id => "myid")
      helper.mobylette_javascript_include_tag("application", "home", :id => "myid").should      == javascript_include_tag("application_mobile", "home_mobile", :id => "myid")
      helper.mobylette_javascript_include_tag("application.js", "home", :id => "myid").should   == javascript_include_tag("application_mobile.js", "home_mobile", :id => "myid")
    end
  end

end
