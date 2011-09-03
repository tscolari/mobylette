require "spec_helper"

describe Mobylette::FallBackResolver do

  it "should fetch formats that exists without fall backing" do
    FORMATS = [:html, :mobile, :xml, :js]

    FORMATS.each do |format|

      resolver  = Mobylette::FallBackResolver.new
      details   = { :formats => [format], :locale => [:en], :handlers => [:erb]}
      resolver.find_all("index", "fallbacks", false, details).empty?.should be_true
    end
  end

  it "should fall back to html when requesting a mobile format that doesnt exists" do
    resolver    = Mobylette::FallBackResolver.new
    details     = { :formats => [:mobile], :locale => [:en], :handlers => [:erb]}
    resolver.find_all("no_mobile", "fallbacks", false, details).empty?.should be_false
  end




end
