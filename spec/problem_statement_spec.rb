require 'spec_helper'

module Topcgen
  describe ProblemStatement do
    it "should parse problem statement 1" do
      html = read_file 'spec/files/statement_dungeon_escape.html'
      stmt = ProblemStatement.new html
      stmt[:method].should eq 'exitTime'
    end

    it "should parse problem statement 2" do
      html = read_file 'spec/files/statement_fountain_of_life.html'
      stmt = ProblemStatement.new html
      stmt[:method].should eq 'elixirOfDeath'
    end

    def read_file file
      File.open(file, 'r') do |f|
        f.rewind
        f.read
      end
    end
  end
end
