require 'spec_helper'

module Topcgen
  module JAVA
    describe 'All' do
      before :each do
        @stream = StringIO.new
      end

      describe Package do
        it "should output the package declaration" do
          stmt = Package.new 'topc.test.graph'
          stmt.gen @stream, 3
          @stream.string.should eq "      package topc.test.graph;\n"
        end
      end

      describe Import do
        it "should output an import declaration" do
          stmt = Import.new 'org.junit.Assert'
          stmt.gen @stream
          @stream.string.should eq "import org.junit.Assert.*;\n"
        end      

        it "should output a static import declaration" do
          stmt = Import.new 'org.junit.Assert', '*', true
          stmt.gen @stream
          @stream.string.should eq "import static org.junit.Assert.*;\n"
        end
      end
    end
  end
end
