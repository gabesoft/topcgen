require 'spec_helper'

module Topcgen
  describe ProblemStatement do
    it "should parse dungeon escape statement" do
      html = read_file 'spec/files/statement_dungeon_escape.html'
      stmt = ProblemStatement.new html
      stmt[:method].should eq 'exitTime'
      stmt.tests.should_not be nil
    end

    it "should parse fountain of life statement" do
      html = read_file 'spec/files/statement_fountain_of_life.html'
      stmt = ProblemStatement.new html
      stmt[:method].should eq 'elixirOfDeath'
    end

    it "should parse quiz show statement" do
      html = read_file 'spec/files/statement_quiz_show.html'
      stmt = ProblemStatement.new html
      stmt[:method].should eq 'wager'
      stmt[:signature].should eq 'int wager(int[] scores, int wager1, int wager2)'
    end

    def read_file file
      File.open(file, 'r') do |f|
        f.rewind
        f.read
      end
    end
  end
end
