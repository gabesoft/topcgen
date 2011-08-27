require 'hpricot'
require 'delegate'

module Topcgen
  class ProblemSolution
    attr_accessor :tests

    def initialize html
      doc = Hpricot.parse html
      container = (doc/'tr').find { |tr| tr.inner_html.include? 'System Test Results' }
      container = (container/'table').find { |tr| tr.inner_html.include? 'System Test Results' }
      container = (container/'table').find { |tr| tr.inner_html.include? 'System Test Results' }

      #puts container
      rows = container/'tr'
      rows = rows[4, rows.length]

      @tests = []
      rows.each do |r|
        cols = r/'td'
        dict = {}
        if cols.length > 1
          dict[:arguments] = safe_html cols[1].inner_html
          dict[:expected] = safe_html cols[3].inner_html
          @tests.push dict
        end
      end
    end

    private

    def safe_html html
      html.gsub(/\s+/, "")
    end
  end
end
