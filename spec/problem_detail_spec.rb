require 'spec_helper'

module Topcgen
  describe ProblemDetail do
    it "should parse game of life problem detail" do
      html = read_file 'spec/files/detail_gameoflife.html'
      detail = ProblemDetail.new html
      detail[:used_in].should eq "TCI '02 Round 4"
    end

    def read_file file
      File.open(file, 'r') do |f|
        f.rewind
        f.read
      end
    end
  end
end
