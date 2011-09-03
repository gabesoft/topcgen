require 'spec_helper'

module Topcgen
  describe ValueParser do
    it "should parse string value" do
      parser = ValueParser.new 'String'
      parser.parse '"abc", {"bc", "de" "f"}, 123'
      parser.match.should eq 'abc'
      parser.match_length.should eq 7
    end

    it "should parse int value" do
      parser = ValueParser.new 'int'
      parser.parse '902, "test", [32, 34, 09], 32L'
      parser.match.should eq 902
      parser.match_length.should eq 5
    end

    it "should parse negative int value" do
      parser = ValueParser.new 'int'
      parser.parse '-902, "test", [32, 34, 09], 32L'
      parser.match.should eq -902
      parser.match_length.should eq 6
    end

    it "should parse long value" do
      parser = ValueParser.new 'long'
      parser.parse '902L, "test", [32, 34, 09], 32L'
      parser.match.should eq 902
      parser.match_length.should eq 6

      parser.parse '8799,9897,2L'
      parser.match.should  eq 8799
      parser.match_length.should eq 5
    end

    it "should parse double value" do
      parser = ValueParser.new 'double'
      parser.parse '-897.32, 89, 32L, "32.23"'
      parser.match.should eq -897.32
      parser.match_length.should eq 9

      parser.parse '324.883, 89, 32L, "32.23"'
      parser.match.should eq 324.883
      parser.match_length.should eq 9
    end

    it "should parse string array" do
      parser = ValueParser.new 'String[]'
      parser.parse '{"abc", "def","klm","de"}, {234,34,9}, "hello", 34L'
      parser.match.should eq [ 'abc', 'def', 'klm', 'de' ]
      parser.match_length.should eq 27
    end

    it "should parse int array" do
      parser = ValueParser.new 'int[]'
      parser.parse '{32, 123,9},{3,42,222L}, "a"'
      parser.match.should eq [ 32, 123, 9 ]
      parser.match_length.should eq 12
    end

    it "should parse long array" do
      parser = ValueParser.new 'long[]'
      parser.parse '{98L,32, 39809787089797870897098789897L,99, 0}, "abc", {}'
      parser.match.should eq [ 98, 32, 39809787089797870897098789897, 99, 0 ]
      parser.match_length.should eq 48
    end

    it "should parse double array" do
      parser = ValueParser.new 'double[]'
      parser.parse '{4.0, 43.98, +2.8, -0.98, 234, 897.1}, {1,3,4,5}, "test"'
      parser.match.should eq [ 4, 43.98, 2.8, -0.98, 234, 897.1 ]
      parser.match_length.should eq 39
    end

    it "should parse multiple values" do
      str = '"test", 9234L,32,{23,4,1},"ola", {"que", "pasa", "hombre"}, 88, {432323L,3, 4, 4, 12}'
      types = [ 'String', 'long', 'int', 'int[]', 'String', 'String[]', 'int', 'long[]' ]
      values = types.map do |t|
        parser = ValueParser.new t
        parser.parse str
        str.slice!(0..parser.match_length - 1)
        parser.match
      end
      values.length.should eq 8
      values.should eq [ 'test', 9234, 32, [ 23, 4, 1 ], 'ola', [ 'que', 'pasa', 'hombre' ], 88, [ 432323, 3, 4, 4, 12 ] ]
    end
  end
end
