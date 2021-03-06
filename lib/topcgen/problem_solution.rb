require 'hpricot'
require 'delegate'

module Topcgen
  class ProblemSolution
    attr_reader :tests

    def initialize html
      doc = Hpricot.parse html

      container = ParseHelper.find_deep(doc, 'table', 'System Test Results')
      rows = container/'tr'

      clean = lambda { |h| ParseHelper.strip_ws (ParseHelper.escape h) }

      @tests = []
      rows.each do |r|
        if !r.nil? && (r.inner_html.include? 'Passed')
          cols = r/'td'
          a_idx = cols.length > 4 ? 1 : 0
          e_idx = cols.length > 4 ? 3 : 1
          dict = {}
          dict[:arguments]  = clean[ cols[a_idx].inner_html ]
          dict[:expected]   = clean[ cols[e_idx].inner_html ]
          @tests.push dict
        end
      end
    rescue
      raise ParseException.new html
    end
  end
end
