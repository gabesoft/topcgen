require 'spec_helper'

module Topcgen
  module JAVA
    describe 'All' do
      before :each do
        @stream = StringIO.new
      end

      describe Class do
        it "should output class" do
          stmt = JAVA.clas 'Kiloman', 
            [ (JAVA.comment 'SRM 234 Div 2 - 1000') ], 
            [ (JAVA.var 'int', 'a', 0) ],
            [ (JAVA.method 'foo', 'int', (JAVA.annotation 'test'), nil, [], [ (JAVA.ret (JAVA.default 'int')) ]) ]
          stmt.gen @stream
          @stream.string.should eq "// SRM 234 Div 2 - 1000\npublic class Kiloman {\n  int a = 0;\n\n  @test\n  public int foo() {\n    return 0;\n  }\n}\n"
        end
      end

      describe Method do
        it "should output method" do
          stmt = JAVA.method('foo', 'int', nil, nil, 
                             [ { :name => 'a', :type => 'long' }, { :name => 'b', :type => 'String' } ], 
                             [ (JAVA.var 'int[]', 'x', (JAVA.arr 'int', [4, 5])), (JAVA.ret (JAVA.val 'int', 0)) ])
          stmt.gen @stream
          @stream.string.should eq "public int foo(long a, String b) {\n  int[] x = new int[] { 4, 5 };\n  return 0;\n}\n"
        end
      end

      describe Return do
        it "should output return statement" do
          stmt = JAVA.ret (JAVA.val 'long', 45)
          stmt.gen @stream
          @stream.string.should eq "return 45L;\n"
        end

        it "should output return null statement" do
          stmt = JAVA.ret (JAVA.default 'int[]')
          stmt.gen @stream
          @stream.string.should eq "return null;\n"
        end
      end

      describe FunCall do
        it "should output function call" do
          stmt = JAVA.call 'foo', (JAVA.call 'bar', (JAVA.val 'String', 'a')), (JAVA.val 'long', 45), 'b'
          stmt.to_s.should eq 'foo(bar("a"), 45L, b)'
        end

        it "should output function call with array parameter" do
          stmt = JAVA.call 'foo', 
            (JAVA.arr 'int', [2,4,5]), 
            (JAVA.arr 'String', (JAVA.val 'String[]', ["a","b"])), 
            (JAVA.val 'long', 5)
          stmt.to_s.should eq 'foo(new int[] { 2, 4, 5 }, new String[] { "a", "b" }, 5L)'
        end
      end

      describe NewArray do
        it "should output array initialized by length" do
          stmt = JAVA.arr 'int', nil, 23
          stmt.to_s.should eq 'new int[23]'
        end

        it "should output array initialized by value" do
          stmt = JAVA.arr 'long', (JAVA.val 'long[]', [4,4,8])
          stmt.to_s.should eq 'new long[] { 4L, 4L, 8L }'
        end
      end

      describe New do
        it "should output constructor" do
          stmt = JAVA.ctor 'MyObject'
          stmt.to_s.should eq 'new MyObject()'
        end
      end

      describe Variable do
        it "should output variable declaration" do
          stmt = JAVA.var 'String', 'a'
          stmt.gen @stream
          @stream.string.should eq "String a;\n"
        end

        it "should output variable declaration and initialization" do
          stmt = JAVA.var 'int[]', 'a', (JAVA.val 'int[]', [ 1, 2, 4 ])
          stmt.gen @stream
          @stream.string.should eq "int[] a = { 1, 2, 4 };\n"
        end

        it "should output variable declaration and initialization with new array" do
          stmt = JAVA.var 'int[]', 'a', (JAVA.arr 'int', (JAVA.val 'int[]', [4,5,9,9]))
          stmt.gen @stream
          @stream.string.should eq "int[] a = new int[] { 4, 5, 9, 9 };\n"
        end
      end

      describe Value do
        it "should output a string array" do
          stmt = JAVA.val 'String[]', [ "ab", "cd", "e", "f" ]
          stmt.to_s.should eq '{ "ab", "cd", "e", "f" }'
        end

        it "should output a long array" do
          stmt = JAVA.val 'long[]', [ 3, 4, 89, 9 ]
          stmt.to_s.should eq '{ 3L, 4L, 89L, 9L }'
        end
      end

      describe Comment do
        it "should output comment line" do
          stmt = JAVA.comment 'this is a comment'
          stmt.gen @stream
          @stream.string.should eq "// this is a comment\n"
        end
      end

      describe Package do
        it "should output the package declaration" do
          stmt = JAVA.pkg 'topc.test.graph'
          stmt.gen @stream, 3
          @stream.string.should eq "      package topc.test.graph;\n"
        end
      end

      describe Import do
        it "should output an import declaration" do
          stmt = JAVA.import 'org.junit.Assert'
          stmt.gen @stream
          @stream.string.should eq "import org.junit.Assert.*;\n"
        end      

        it "should output a static import declaration" do
          stmt = JAVA.import 'org.junit.Assert', '*', true
          stmt.gen @stream
          @stream.string.should eq "import static org.junit.Assert.*;\n"
        end
      end
    end
  end
end
