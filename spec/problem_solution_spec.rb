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

    it "should parse collision problem" do
      html = read_file 'spec/files/solution_collision.html'
      stmt = ProblemSolution.new html

      stmt.tests.length.should > 0
      stmt.tests[4].should eq ({:arguments=>"{6159, 4927, 6323, 2339, 7797, 9793, 6654, 5711, 5326, 3700, 945, 3340, 738, 5359, 9794, 5659, 7476, 8771, 483, 6621, 2119, 6778, 7009, 3695, 7841, 8748, 9044, 2376, 5703, 1783, 4337, 9436, 9444, 9440, 57, 5176, 9658, 1417, 5417, 3909, 9897, 7066, 6760},\n2001034851", :expected=>"1.6742947149701077E-7"})
    end

    def read_file file
      File.open(file, 'r') do |f|
        f.rewind
        f.read
      end
    end
  end
end
