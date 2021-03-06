require 'hpricot'
require 'delegate'

module Topcgen
  class ProblemDetail < DelegateClass(Hash)
    def initialize html
      doc = Hpricot.parse html
      container = doc/'div.statTableIndent'

      stmt_link = (container/'a.statText').find do |a|
        a.attributes['href'] =~ /problem_statement|HSProblemStatement/i
      end
      round_link = (container/'a.statText').find do |a|
        a.attributes['href'] =~ /round_overview|HSRoundOverview/i
      end
      row_used_as = (container/'tr').find { |tr| tr.inner_html.include? 'Used As:' }
      row_categories = (container/'tr').find { |tr| tr.inner_html.include? 'Categories:' }
      row_point_value = (container/'tr').find { |tr| tr.inner_html.include? 'Point Value' }
      row_solution = (container/'tr').find { |tr| tr.inner_html.include? 'Top Submission' }
      solution_links = row_solution/'a.statText'

      strip = lambda { |h| ParseHelper.escape(ParseHelper.strip_ws h) }
      split = lambda { |h, c| ParseHelper.split (ParseHelper.escape h), c }

      @data = {}

      @data[:name]                  = strip[ stmt_link.inner_html ]
      @data[:used_in]               = strip[ round_link.inner_html ]
      @data[:categories]            = strip[ (row_categories/'td')[1].inner_html ]

      @data[:used_as]               = split[ (row_used_as/'td')[1].inner_html, ',' ][0]
      @data[:point_value]           = split[ (row_point_value/'td')[1].inner_html, ',' ][0]

      @data[:solution_java]         = solution_links[0].attributes['href'] unless solution_links.length < 2
      @data[:solution_cpp]          = solution_links[1].attributes['href'] unless solution_links.length < 3
      @data[:solution_csharp]       = solution_links[2].attributes['href'] unless solution_links.length < 4
      @data[:solution_vb]           = solution_links[3].attributes['href'] unless solution_links.length < 5

      @data[:statement_link]        = stmt_link.attributes['href']
      super(@data)
    rescue Exception => e
      raise ParseException.new html 
    end
  end
end
