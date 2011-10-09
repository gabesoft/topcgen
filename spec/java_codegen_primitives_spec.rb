require 'spec_helper'

module Topcgen
  module JAVA
    describe 'All' do
      before :each do
        @stream = StringIO.new
      end

      describe ClassGen do
        it "should output class" do
          method = JAVA.method 'foo', 'int', [], [ (JAVA.ret (JAVA.default 'int')) ], (JAVA.annotation 'test')
          afield = JAVA.var 'int', 'a', 0
          clas = JAVA.clas 'Kiloman', [ afield ], [ method ], [ (JAVA.comment 'SRM 234 Div 2 - 1000') ]
          clas.gen @stream
          @stream.string.should eq "// SRM 234 Div 2 - 1000\npublic class Kiloman {\n  int a = 0;\n\n  @test\n  public int foo() {\n    return 0;\n  }\n}\n"
        end
      end

      describe MethodGen do
        it "should output method" do
          stmt = JAVA.method('foo', 'int', 
                             [ { :name => 'a', :type => 'long' }, { :name => 'b', :type => 'String' } ], 
                             [ (JAVA.var 'int[]', 'x', (JAVA.arr 'int', [4, 5])), (JAVA.ret (JAVA.val 'int', 0)) ])
          stmt.gen @stream
          @stream.string.should eq "public int foo(long a, String b) {\n  int[] x = new int[] { 4, 5 };\n  return 0;\n}\n"
        end
      end

      describe ReturnGen do
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

      describe FunCallGen do
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

      describe NewArrayGen do
        it "should output array initialized by length" do
          stmt = JAVA.arr 'int', nil, 23
          stmt.to_s.should eq 'new int[23]'
        end

        it "should output long array initialized by value" do
          stmt = JAVA.arr 'long', (JAVA.val 'long[]', [4,4,8])
          stmt.to_s.should eq 'new long[] { 4L, 4L, 8L }'
        end

        it "should output string array initialized by value" do
          stmt = JAVA.arr 'String[]', [ "BBBAB", "NO PAGE", "AABAB", "BBBBB", "NO PAGE" ]
          stmt.to_s.should eq 'new String[] { "BBBAB", "NO PAGE", "AABAB", "BBBBB", "NO PAGE" }'
        end
      end

      describe NewGen do
        it "should output constructor" do
          stmt = JAVA.ctor 'MyObject'
          stmt.to_s.should eq 'new MyObject()'
        end
      end

      describe VariableGen do
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

      describe ValueGen do
        it "should output a string array" do
          stmt = JAVA.val 'String[]', [ "ab", "cd", "e", "f" ]
          stmt.to_s.should eq '{ "ab", "cd", "e", "f" }'
        end

        it "should output a string array with commas" do
          stmt = JAVA.val 'String[]', [ "000, 030, 030, 040, 000, 000, 000", "020, 020, 020, 010, 010, 010, 010" ]
          stmt.to_s.should eq '{ "000, 030, 030, 040, 000, 000, 000", "020, 020, 020, 010, 010, 010, 010" }'
        end

        it "should output a long array" do
          stmt = JAVA.val 'long[]', [ 3, 4, 89, 9 ]
          stmt.to_s.should eq '{ 3L, 4L, 89L, 9L }'
        end

        it "should output a double" do
          stmt = JAVA.val 'double', -4234.90
          stmt.to_s.should eq '-4234.9'
        end

        it "should output a double in scientific notation" do
          stmt = JAVA.val 'double', 1.6742947149701077E-7
          stmt.to_s.should eq '1.6742947149701077e-07'
        end

        it "should fail to output an int passed in in a single value array" do
          lambda { JAVA.val 'int', [439] }.should raise_error
        end

        it "should fail to output an int passed in in a multiple value array" do
          lambda { JAVA.val 'int', [439, 324] }.should raise_error
        end
      end

      describe CommentGen do
        it "should output comment line" do
          stmt = JAVA.comment 'this is a comment'
          stmt.gen @stream
          @stream.string.should eq "// this is a comment\n"
        end
      end

      describe PackageGen do
        it "should output the package declaration" do
          stmt = JAVA.pkg 'topc.test.graph'
          stmt.gen @stream, 3
          @stream.string.should eq "      package topc.test.graph;\n"
        end
      end

      describe ImportGen do
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

      describe BinaryOperationGen do
        it "should output an addition operation" do
          stmt = JAVA.binop '+', (JAVA.val 'double', 1.4), 'DELTA'
          stmt.to_s.should eq "1.4 + DELTA"
        end
      end
    end
  end
end
