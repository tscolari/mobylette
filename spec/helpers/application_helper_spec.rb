require 'spec_helper'

describe ApplicationHelper do
  
  describe "mobylette_stylesheet_link_tag" do
    it "should not change the files names when the request is not mobile" do
      helper.mobylette_stylesheet_link_tag("application").should              == mobylette_stylesheet_link_tag("application") 
      helper.mobylette_stylesheet_link_tag("application.css").should          == mobylette_stylesheet_link_tag("application.css") 
      helper.mobylette_stylesheet_link_tag("application", "home").should      == mobylette_stylesheet_link_tag("application", "home") 
      helper.mobylette_stylesheet_link_tag("application.css", "home").should  == mobylette_stylesheet_link_tag("application.css", "home") 
    end

    it "should add the '_mobile' sulfix to the files names when the request is mobile" do
      force_mobile_request_agent("Android") 
      helper.mobylette_stylesheet_link_tag("application").should              == mobylette_stylesheet_link_tag("application_mobile")
      helper.mobylette_stylesheet_link_tag("application.css").should          == mobylette_stylesheet_link_tag("application_mobile.css")
      helper.mobylette_stylesheet_link_tag("application", "home").should      == mobylette_stylesheet_link_tag("application_mobile", "home_mobile")
      helper.mobylette_stylesheet_link_tag("application.css", "home").should  == mobylette_stylesheet_link_tag("application_mobile.css", "home_mobile")
    end
  end

  describe "mobylette_javascript_include_tag" do
    it "should not change the files names when the request is not mobile" do
      helper.mobylette_javascript_include_tag("application").should              == mobylette_stylesheet_link_tag("application")
      helper.mobylette_javascript_include_tag("application.js").should           == mobylette_stylesheet_link_tag("application.js")
      helper.mobylette_javascript_include_tag("application", "home").should      == mobylette_stylesheet_link_tag("application", "home")
      helper.mobylette_javascript_include_tag("application.js", "home").should   == mobylette_stylesheet_link_tag("application.js", "home")
    end

    it "should add the '_mobile' sulfix to the files names when the request is mobile" do
      force_mobile_request_agent("Android") 
      helper.mobylette_javascript_include_tag("application").should              == mobylette_stylesheet_link_tag("application_mobile")
      helper.mobylette_javascript_include_tag("application.js").should           == mobylette_stylesheet_link_tag("application_mobile.js")
      helper.mobylette_javascript_include_tag("application", "home").should      == mobylette_stylesheet_link_tag("application_mobile", "home_mobile")
      helper.mobylette_javascript_include_tag("application.js", "home").should   == mobylette_stylesheet_link_tag("application_mobile.js", "home_mobile")
    end
  end

end
