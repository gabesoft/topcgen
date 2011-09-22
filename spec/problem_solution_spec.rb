require 'spec_helper'

module Topcgen
  describe ProblemSolution do
    it "should parse dungeon_escape problem" do
      html = read_file 'spec/files/solution_dungeon_escape.html'
      stmt = ProblemSolution.new html
      stmt.tests.length.should > 0
    end

    it "should parse fountain_of_life problem" do
      html = read_file 'spec/files/solution_fountain_of_life.html'
      stmt = ProblemSolution.new html
      stmt.tests.length.should > 0
    end

    it "should parse weird_rooks problem" do
      html = read_file 'spec/files/solution_weird_rooks.html'
      stmt = ProblemSolution.new html

      stmt.tests.length.should > 0
      stmt.tests[2].should eq ({:arguments => '{1, 2, 3}', :expected => '"0,6 1,3 1,4 1,5 2,1 2,2 2,3 3,0"'})
    end

    it "should parse gold_mine problem" do
      html = read_file 'spec/files/solution_gold_mine.html'
      stmt = ProblemSolution.new html

      stmt.tests.length.should > 0
      stmt.tests[0].should eq ({:arguments=>"{\"000, 030, 030, 040, 000, 000, 000\", \"020, 020, 020, 010, 010, 010, 010\"},\n                      4", :expected=>"{2, 2}"})
    end

    def read_file file
      File.open(file, 'r') do |f|
        f.rewind
        f.read
      end
    end
  end
end
