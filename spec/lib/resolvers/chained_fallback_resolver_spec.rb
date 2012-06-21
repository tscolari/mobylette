require 'spec_helper'

module Mobylette
  module Resolvers
    describe ChainedFallbackResolver do

      describe "#find_templates" do

        context "single fallback chain" do
          [
            { mobile: [:mobile, :html]},
            { iphone: [:iphone, :mobile, :html]}
          ].each do |fallback_chain|
            context "fallback chain = #{fallback_chain.to_s}" do
              subject { Mobylette::Resolvers::ChainedFallbackResolver.new(fallback_chain) }

              it "should change details[:formats] to the fallback array" do
                details = { formats: [fallback_chain.keys.first] }
                details.stub(:dup).and_return(details)
                subject.find_templates("", "", "", details)
                details[:formats].should == fallback_chain.values.first
              end

            end
          end
        end

        context "multiple fallback chains" do
          fallback_chains = {iphone: [:iphone, :mobile, :html], android: [:android, :html], mobile: [:mobile, :html]}
          subject { Mobylette::Resolvers::ChainedFallbackResolver.new(fallback_chains) }

          fallback_chains.each_pair do |format, fallback_array|
            context "#{format} format" do
              it "should change details[:formats] to the fallback array" do
                details = { formats: [format] } 
                details.stub(:dup).and_return(details)
                subject.find_templates("", "", "", details)
                details[:formats].should == fallback_array
              end
            end
          end
        end

      end
    end
  end
end
