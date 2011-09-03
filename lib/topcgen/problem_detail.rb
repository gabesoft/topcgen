require 'hpricot'
require 'delegate'

module Topcgen
  class ProblemDetail < DelegateClass(Hash)
    def initialize html
      # TODO: used_as could come in as a multiple items comma separated see MagicCube
      #       need to use the tests in statement if the solution page is not available
      #       there are html characters in the used_in string see GameOfLife
      begin
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

        @data = {}
        @data[:name]            = clean_html stmt_link.inner_html
        @data[:statement_link]  = stmt_link.attributes['href']
        @data[:used_in]         = clean_html round_link.inner_html
        @data[:used_as]         = clean_and_split((row_used_as/'td')[1].inner_html, ',')[0]
        @data[:categories]      = clean_html (row_categories/'td')[1].inner_html
        @data[:point_value]     = clean_and_split((row_point_value/'td')[1].inner_html, ',')[0]
        @data[:solution_java]   = solution_links[0].attributes['href'] unless solution_links.length < 2
        @data[:solution_cpp]    = solution_links[1].attributes['href'] unless solution_links.length < 3
        @data[:solution_csharp] = solution_links[2].attributes['href'] unless solution_links.length < 4
        @data[:solution_vb]     = solution_links[3].attributes['href'] unless solution_links.length < 5

        super(@data)
      rescue Exception => e
        $log.error 'ProblemDetail: parsing html failed'
        $log.error e.message
        $log.error e.backtrace.inspect
        $log.error html.strip() unless html.nil?
        raise e
      end
    end

    private

    def clean_html html
      html.strip
    end

    def clean_and_split(html, char)
      clean = clean_html html
      clean.split(/#{char}\s*/).map { |e| clean_html e }
    end
  end
end
