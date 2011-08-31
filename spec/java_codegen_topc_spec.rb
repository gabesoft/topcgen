require 'spec_helper'

module Topcgen
  module JAVA
    describe JAVA do
      it "should generate the problem class" do
        info = {:name=>"KiloManX", :statement_link=>"/stat?c=problem_statement&pm=2288&rd=4725", :used_in=>"SRM 181", :used_as=>"Division I Level Three", :categories=>"Dynamic Programming, Search", :point_value=>"1000", :solution_java=>"/stat?c=problem_solution&cr=277659&rd=4725&pm=2288", :solution_cpp=>"/stat?c=problem_solution&cr=262936&rd=4725&pm=2288"}
        stmt = {:class=>"KiloManX", :method=>"leastShots", :parameters=>"String[], int[]", :returns=>"int[]", :signature=>"int[] leastShots(String[] damageChart, int[] bossHealth)"}
        tests = [
          {:arguments=>"{\"070\",\"500\",\"140\"},{150,150,150}", :expected=>"{ 218 }"},
          {:arguments=>"{\"1542\",\"7935\",\"1139\",\"8882\"},{150,150,150,150}", :expected=>"{ 205 }"},
          {:arguments=>"{\"07\",\"40\"},{150,10}", :expected=>"{ 48 }"}
        ]
        method = MethodParser.new stmt[:method], stmt[:parameters], stmt[:returns], stmt[:signature]
        values = tests.map do |t|
          a_types = method.parameters.map { |p| p[:type] }
          r_types = [ stmt[:returns] ]
          { :arguments => parse(a_types, t[:arguments]), :expected => parse(r_types, t[:expected]) }
        end
        JAVA.problem_class(nil, nil).should eq 'not_implemented'
      end

      # TODO: move to ValueParser.parse
      def parse(types, values)
        str = values
        types.map do |t|
          parser = ValueParser.new t
          parser.parse str
          str.slice!(0..parser.match_length - 1)
          parser.match
        end
      end
    end
  end
end

