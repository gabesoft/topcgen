require 'spec_helper'

module Topcgen
  describe ProblemSolution do
    it "should parse problem solution 1" do
      html = read_file 'spec/files/solution_dungeon_escape.html'
      stmt = ProblemSolution.new html
      stmt.tests.length.should > 0
    end

    it "should parse problem solution 2" do
      html = read_file 'spec/files/solution_fountain_of_life.html'
      stmt = ProblemSolution.new html
      stmt.tests.length.should > 0
    end

    it "should parse problem solution 3" do
      html = read_file 'spec/files/solution_weird_rooks.html'
      stmt = ProblemSolution.new html

      stmt.tests.length.should > 0
      stmt.tests[2].should eq ({:arguments => '{1, 2, 3}', :expected => '"0,6 1,3 1,4 1,5 2,1 2,2 2,3 3,0"'})
    end

    def read_file file
      File.open(file, 'r') do |f|
        f.rewind
        f.read
      end
    end
  end
end
