require 'hpricot'
require 'delegate'

module Topcgen
  class ProblemSolution
    attr_reader :tests

    def initialize html
      begin
        doc = Hpricot.parse html

        # TODO: put find_container in a central location
        container = find_container doc
        rows = container/'tr'

        @tests = []
        rows.each do |r|
          if !r.nil? && (r.inner_html.include? 'Passed')
            cols = r/'td'
            a_idx = cols.length > 4 ? 1 : 0
            e_idx = cols.length > 4 ? 3 : 1
            dict = {}
            dict[:arguments] = safe_html cols[a_idx].inner_html
            dict[:expected] = safe_html cols[e_idx].inner_html
            @tests.push dict
          end
        end
      rescue Exception => e
        $log.error 'ProblemSolution: parsing html failed'
        $log.error e.message
        $log.error e.backtrace.inspect
        $log.error html.strip() unless html.nil?
        raise e
      end
    end

    private

    def find_container doc
      continue = true
      labels = [ 'System Test Results' ]
      container = (doc/'table').find { |t| labels.all? { |s| t.inner_html.include? s } }

      temp = nil
      while continue
        temp = (container/'table').find { |t| labels.all? { |s| t.inner_html.include? s } } 
        container = temp unless temp.nil?
        continue = !!temp
      end

      container
    end

    def safe_html html
      html.gsub(/\s+/, "")
    end
  end
end
