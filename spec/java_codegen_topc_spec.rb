require 'spec_helper'

module Topcgen
  module JAVA
    describe JAVA do
      before :each do
        @info = {:name=>"KiloManX", :statement_link=>"/stat?c=problem_statement&pm=2288&rd=4725", 
                :used_in=>"SRM 181", :used_as=>"Division I Level Three", 
                :categories=>"Dynamic Programming, Search", :point_value=>"1000", 
                :solution_java=>"/stat?c=problem_solution&cr=277659&rd=4725&pm=2288", 
                :solution_cpp=>"/stat?c=problem_solution&cr=262936&rd=4725&pm=2288"}
        @info[:statement_link_full] = 'http://community.topcoder.com' + @info[:statement_link]
        @info[:package_root] = 'topc'

        @stmt = {:class=>"KiloManX", :method=>"leastShots", :parameters=>"String[], int[]", :returns=>"int[]", :signature=>"int[] leastShots(String[] damageChart, int[] bossHealth)"}
        @tests = [
          {:arguments=>"{\"070\",\"500\",\"140\"},{150,150,150}", :expected=>"{ 218 }"},
          {:arguments=>"{\"1542\",\"7935\",\"1139\",\"8882\"},{150,150,150,150}", :expected=>"{ 205 }"},
          {:arguments=>"{\"07\",\"40\"},{150,10}", :expected=>"{ 48 }"}
        ]

        @method = MethodParser.new @stmt[:method], @stmt[:parameters], @stmt[:returns], @stmt[:signature]
      end

      it "should generate the problem class" do
        @info[:main_imports] = [ 
          { :path => 'java.util' }, 
          { :path => 'java.io' }
        ]

        stream = StringIO.new
        file = read_file 'spec/files/KiloManX.java'

        JAVA.main_class(stream, @method, @info)
        stream.string.should eq file

        stream.close
      end

      it "should generate the unit tests" do
        values = @tests.map do |t|
          a_types = @method.parameters.map { |p| p[:type] }
          r_types = [ @stmt[:returns] ]
          arguments = ValueParser.parse a_types, t[:arguments]
          expected = ValueParser.parse r_types, t[:expected]
          { :arguments => arguments, :expected => expected[0] }
        end
        
        @info[:test_imports] = [ 
          { :path => 'junit.framework' },
          { :path => 'org.junit', :object => 'Test' },
          { :path => 'org.junit.Assert', :static => true } 
        ]

        stream = StringIO.new
        file = read_file 'spec/files/KiloManXTest.java'

        JAVA.test_class(stream, @method, @info, values)
        stream.string.should eq file

        stream.close
      end

      def read_file file
        File.open(file, 'r') do |f|
          f.rewind
          f.read
        end
      end
    end
  end
end

